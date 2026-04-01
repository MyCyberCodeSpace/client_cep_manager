import 'package:http/http.dart' as http;
import 'dart:convert';

class ViaCepService {
  final http.Client client;

  ViaCepService(this.client);

  Future<Map<String, dynamic>> searchCEP(int cep) async {
    try {
      final url = Uri.https('viacep.com.br', '/ws/$cep/json/');
      final response = await client.get(url);

      if (response.statusCode >= 400) {
        return {'erro': 'Erro na consulta ao ViaCEP'};
      }

      final Map<String, dynamic> data = json.decode(response.body);

      if (data['erro'] == 'true') {
        return {'erro': 'CEP não encontrado.'};
      }

      return {
        'estado': data['estado'],
        'cidade': data['localidade'],
        'bairro': data['bairro'],
        'endereco': data['logradouro'],
      };
    } catch (e) {
      return {'erro': 'Ocorreu um erro: $e'};
    }
  }
}
