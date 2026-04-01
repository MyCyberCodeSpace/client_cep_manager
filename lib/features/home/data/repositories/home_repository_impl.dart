import 'package:log_aqua_app/core/models/client_model.dart';
import 'package:log_aqua_app/features/home/domain/repositories/home_repository.dart';
import 'package:sqflite/sqflite.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Database database;

  HomeRepositoryImpl(this.database);

  @override
  Future<List<ClientModel>> getAllUsers() async {
    final List<Map<String, dynamic>> maps = await database.query(
      'clientes',
      orderBy: 'ultimaAtualizacao DESC',
    );
    final List<ClientModel> listaCliente = [];

    for (var clientMap in maps) {
      listaCliente.add(
        ClientModel(
          id: clientMap['id'],
          nomeCompleto: clientMap['nomeCompleto'],
          cep: clientMap['cep'],
          estado: clientMap['estado'],
          cidade: clientMap['cidade'],
          bairro: clientMap['bairro'],
          endereco: clientMap['endereco'],
          ultimaAtualizacao: clientMap['ultimaAtualizacao'],
        ),
      );
    }

    return listaCliente;
  }
}
