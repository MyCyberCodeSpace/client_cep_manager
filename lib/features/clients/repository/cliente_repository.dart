import 'package:log_aqua_app/core/models/client_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClienteRepository {
  final Database database;
  final http.Client client;

  ClienteRepository(this.database, this.client);

  String formatarData(String dataIso) {
    final dt = DateTime.parse(dataIso);

    String doisDigitos(int n) => n.toString().padLeft(2, '0');

    final dia = doisDigitos(dt.day);
    final mes = doisDigitos(dt.month);
    final ano = dt.year;
    final hora = doisDigitos(dt.hour);
    final minuto = doisDigitos(dt.minute);

    return '$dia/$mes/$ano às ${hora}h:${minuto}m';
  }

  Future<void> addClient(ClientModel cliente) async {
    final dados = await viaCepApi(cliente.cep);
    if (dados.containsKey('erro')) {
      throw ('CEP inválido: ${dados['erro']}');
    }
    await database.insert('clientes', {
      'nomeCompleto': cliente.nomeCompleto,
      'cep': cliente.cep,
      'estado': (cliente.estado.isEmpty && dados['estado'] != null)
          ? dados['estado']
          : cliente.estado,
      'cidade': (cliente.cidade.isEmpty && dados['cidade'] != null)
          ? dados['cidade']
          : cliente.cidade,
      'bairro': (cliente.bairro.isEmpty && dados['bairro'] != null)
          ? dados['bairro']
          : cliente.bairro,
      'endereco':
          (cliente.endereco.isEmpty && dados['endereco'] != null)
          ? dados['endereco']
          : cliente.endereco,
      'ultimaAtualizacao': cliente.ultimaAtualizacao,
    });
  }

  Future<ClientModel> updateClient(ClientModel cliente) async {
    final dados = await viaCepApi(cliente.cep);

    if (dados.containsKey('erro')) {
      throw ('Para a consulta do cep ${cliente.cep} aconteceu algum erro. Verifique o cep digitado.');
    }
    ClientModel newClientData = ClientModel(
      nomeCompleto: cliente.nomeCompleto,
      cep: cliente.cep,
      estado: dados['estado'],
      cidade: dados['cidade'],
      bairro: dados['bairro'],
      endereco: dados['endereco'],
      ultimaAtualizacao: DateTime.now().toIso8601String(),
    );

    await database.update(
      'clientes',
      {
        'nomeCompleto': newClientData.nomeCompleto,
        'cep': newClientData.cep,
        'estado': newClientData.estado,
        'cidade': newClientData.cidade,
        'bairro': newClientData.bairro,
        'endereco': newClientData.endereco,
        'ultimaAtualizacao': newClientData.ultimaAtualizacao,
      },
      where: 'id = ?',
      whereArgs: [cliente.id],
    );

    return newClientData;
  }

  Future<int> removeClient(ClientModel cliente) async {
    return await database.delete(
      'clientes',
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<List<ClientModel>> getAllClients() async {
    final List<Map<String, dynamic>> maps = await database.query(
      'clientes',
      orderBy: 'ultimaAtualizacao DESC',
    );
    final List<ClientModel> listaCliente = [];

    for (var clientMap in maps) {
      listaCliente.add(
        ClientModel(
          id: clientMap['id'] as int,
          nomeCompleto: clientMap['nomeCompleto'] as String,
          cep: clientMap['cep'] as int,
          estado: clientMap['estado'] as String,
          cidade: clientMap['cidade'] as String,
          bairro: clientMap['bairro'] as String,
          endereco: clientMap['endereco'] as String,
          ultimaAtualizacao: clientMap['ultimaAtualizacao'] as String,
        ),
      );
    }
    if (listaCliente.isNotEmpty) {
      listaCliente[0].ultimaAtualizacao = formatarData(
        listaCliente[0].ultimaAtualizacao,
      );
    }
    return listaCliente;
  }

  Future<Map<String, dynamic>> viaCepApi(int cep) async {
    try {
      final url = Uri.https('viacep.com.br', '/ws/$cep/json/');
      final response = await client.get(url);

      if (response.statusCode >= 400) {
        return {'erro': 'Erro na consulta ao ViaCEP'};
      }

      final Map<String, dynamic> listData = json.decode(
        response.body,
      );

      if (listData['erro'] == 'true') {
        return {'erro': 'CEP não encontrado.'};
      }

      return {
        'estado': listData['estado'],
        'cidade': listData['localidade'],
        'bairro': listData['bairro'],
        'endereco': listData['logradouro'],
      };
    } catch (e) {
      return {'erro': 'Ocorreu um erro: $e'};
    }
  }
}
