import 'package:log_aqua_app/core/models/client_model.dart';
import 'package:log_aqua_app/features/clients/domain/repositories/client_repository.dart';
import 'package:log_aqua_app/features/clients/domain/typedefs/client_typedefs.dart';
import 'package:log_aqua_app/features/clients/data/services/via_cep_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class ClientRepositoryImpl implements ClientRepository {
  final Database database;
  final ViaCepService viaCepService;

  ClientRepositoryImpl(this.database, http.Client client)
    : viaCepService = ViaCepService(client);

  String _formatarData(String dataIso) {
    final dt = DateTime.parse(dataIso);

    String doisDigitos(int n) => n.toString().padLeft(2, '0');

    final dia = doisDigitos(dt.day);
    final mes = doisDigitos(dt.month);
    final ano = dt.year;
    final hora = doisDigitos(dt.hour);
    final minuto = doisDigitos(dt.minute);

    return '$dia/$mes/$ano às ${hora}h:${minuto}m';
  }

  @override
  FutureVoid addClient(ClientModel cliente) async {
    final dados = await searchCEP(cliente.cep);
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

  @override
  FutureClient updateClient(ClientModel cliente) async {
    final dados = await searchCEP(cliente.cep);

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

  @override
  FutureInt removeClient(ClientModel cliente) async {
    return await database.delete(
      'clientes',
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  @override
  FutureClientList getAllClients() async {
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
      listaCliente[0].ultimaAtualizacao = _formatarData(
        listaCliente[0].ultimaAtualizacao,
      );
    }
    return listaCliente;
  }

  @override
  FutureCepData searchCEP(int cep) async {
    return await viaCepService.searchCEP(cep);
  }
}
