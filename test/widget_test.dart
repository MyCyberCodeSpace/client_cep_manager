// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:log_aqua_app/core/data/initial_client_data.dart';
import 'package:log_aqua_app/core/models/client_model.dart';
import 'package:log_aqua_app/features/clients/repository/cliente_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late ClienteRepository clienteRepository;
  final database = await databaseFactory.openDatabase(
    inMemoryDatabasePath,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE clientes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nomeCompleto TEXT NOT NULL,
          cep INTEGER NoriOT NULL,
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
    ),
  );

  setUp(() {
    clienteRepository = ClienteRepository(database, http.Client());
  });

  group('formatarData', () {
    test('deve formatar corretamente uma data ISO completa', () {
      final iso = "2023-08-15T14:05:00.000Z";
      final resultado = clienteRepository.formatarData(iso);

      expect(resultado, "15/08/2023 às 14h:05m");
    });

    test('deve adicionar zero à esquerda em dia, mês e minuto', () {
      final iso = "2023-01-05T09:03:00.000Z";
      final resultado = clienteRepository.formatarData(iso);

      expect(resultado, "05/01/2023 às 09h:03m");
    });

    test('deve lidar com meia-noite corretamente', () {
      final iso = "2023-12-31T00:00:00.000Z";
      final resultado = clienteRepository.formatarData(iso);

      expect(resultado, "31/12/2023 às 00h:00m");
    });
  });

  group('consultApi', () {
    test('cep invalido - deve retornar mensagem de erro', () async {
      final result = await clienteRepository.viaCepApi(12378);
      expect(result['erro'], 'Erro na consulta ao ViaCEP');
    });

    test(
      'cep não existente - deve retornar mensagem de erro',
      () async {
        final result = await clienteRepository.viaCepApi(12345678);
        expect(result['erro'], 'CEP não encontrado.');
      },
    );

    test('cep válido - deve retornar os dados', () async {
      final result = await clienteRepository.viaCepApi(88304900);
      expect(result['estado'], 'Santa Catarina');
      expect(result['cidade'], 'Itajaí');
      expect(result['bairro'], 'Vila Operária');
      expect(result['endereco'], 'Rua Alberto Werner');
    });

    group('Testes no banco de dados', () {
      test('remover cliente do banco de dados', () async {
        final List<Map<String, dynamic>> mapsBefore = await database
            .query('clientes', orderBy: 'ultimaAtualizacao DESC');

        final ClientModel clientBefore = ClientModel(
          id: mapsBefore[0]['id'] as int,
          nomeCompleto: mapsBefore[0]['nomeCompleto'] as String,
          cep: mapsBefore[0]['cep'] as int,
          estado: mapsBefore[0]['estado'] as String,
          cidade: mapsBefore[0]['cidade'] as String,
          bairro: mapsBefore[0]['bairro'] as String,
          endereco: mapsBefore[0]['endereco'] as String,
          ultimaAtualizacao:
              mapsBefore[0]['ultimaAtualizacao'] as String,
        );

        final result = await clienteRepository.removeClient(
          clientBefore,
        );

        final List<Map<String, dynamic>> mapsAfter = await database
            .query('clientes', orderBy: 'ultimaAtualizacao DESC');
        final ClientModel clienteAfter = ClientModel(
          id: mapsAfter[0]['id'] as int,
          nomeCompleto: mapsAfter[0]['nomeCompleto'] as String,
          cep: mapsAfter[0]['cep'] as int,
          estado: mapsAfter[0]['estado'] as String,
          cidade: mapsAfter[0]['cidade'] as String,
          bairro: mapsAfter[0]['bairro'] as String,
          endereco: mapsAfter[0]['endereco'] as String,
          ultimaAtualizacao:
              mapsAfter[0]['ultimaAtualizacao'] as String,
        );

        expect(clientBefore.id != clienteAfter.id, true);
      });
    });
  });
}
