// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:log_aqua_app/features/clients/repository/cliente_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  late ClienteRepository clienteRepository;

  setUp(() {
    clienteRepository = ClienteRepository(
      MockDatabase(),
      http.Client(),
    );
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
  });
}
