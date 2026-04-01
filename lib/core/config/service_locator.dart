import 'package:http/http.dart' as http;
import 'package:log_aqua_app/core/data/initial_client_data.dart';
import 'package:log_aqua_app/features/clients/presentation/bloc/client_bloc.dart';
import 'package:log_aqua_app/features/clients/data/repositories/client_repository_impl.dart';
import 'package:log_aqua_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:log_aqua_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class ServiceLocator {
  static late Database _database;

  static Database get database => _database;

  static Future<void> setupDependencies() async {
    // Inicializar banco de dados
    _database = await _initializeDatabase();
  }

  static Future<Database> _initializeDatabase() async {
    final database = await openDatabase(
      p.join(await getDatabasesPath(), 'just_user_focus.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE clientes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nomeCompleto TEXT NOT NULL,
            cep INTEGER NOT NULL,
            estado TEXT NOT NULL,
            cidade TEXT NOT NULL,
            bairro TEXT NOT NULL,
            endereco TEXT NOT NULL,
            ultimaAtualizacao TEXT NOT NULL
          );
        ''');
        for (var cliente in listaClientes) {
          await db.insert('clientes', {
            'nomeCompleto': cliente.nomeCompleto,
            'cep': cliente.cep,
            'estado': cliente.estado,
            'cidade': cliente.cidade,
            'bairro': cliente.bairro,
            'endereco': cliente.endereco,
            'ultimaAtualizacao': cliente.ultimaAtualizacao,
          });
        }
      },
    );
    return database;
  }

  // BLoCs
  static ClientBloc getClientBloc() {
    return ClientBloc(ClientRepositoryImpl(_database, http.Client()));
  }

  static HomeBloc getHomeBloc() {
    return HomeBloc(HomeRepositoryImpl(_database));
  }
}
