import 'package:log_aqua_app/core/models/client_model.dart';

final List<ClientModel> listaClientes = [
  ClientModel(
    nomeCompleto:
        'Danielle - Texto Mais Longo Para Extrapolar Limites',
    cep: 88304900,
    estado: 'Santa Catarina',
    cidade: 'Itajaí',
    bairro: 'Vila Operária',
    endereco: 'Rua Alberto Werner',
    ultimaAtualizacao: DateTime.now().toIso8601String(),
  ),

  ClientModel(
    nomeCompleto: 'Augusto',
    cep: 88304900,
    estado: 'Santa Catarina',
    cidade: 'Itajaí',
    bairro: 'Vila Operária',
    endereco: 'Rua Alberto Werner',
    ultimaAtualizacao: DateTime.now().toIso8601String(),
  ),

  ClientModel(
    nomeCompleto: 'Gustavo',
    cep: 87654321,
    estado: 'RJ',
    cidade: 'Rio de Janeiro',
    bairro: 'Copacabana',
    endereco: 'Avenida Atlântica, 456',
    ultimaAtualizacao: DateTime.now().toIso8601String(),
  ),

  ClientModel(
    nomeCompleto: 'Mateus',
    cep: 88304900,
    estado: 'Santa Catarina',
    cidade: 'Itajaí',
    bairro: 'Vila Operária',
    endereco: 'Rua Alberto Werner',
    ultimaAtualizacao: DateTime.now().toIso8601String(),
  ),

  ClientModel(
    nomeCompleto: 'Cleiton',
    cep: 88304900,
    estado: 'Santa Catarina',
    cidade: 'Itajaí',
    bairro: 'Vila Operária',
    endereco: 'Rua Alberto Werner',
    ultimaAtualizacao: DateTime.now().toIso8601String(),
  ),
];
