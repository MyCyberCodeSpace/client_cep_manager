class ClientModel {
  final int? id;
  final String nomeCompleto;
  final int cep;
  final String estado;
  final String cidade;
  final String bairro;
  final String endereco;
  String ultimaAtualizacao;

  ClientModel({
    this.id,
    required this.nomeCompleto,
    required this.cep,
    required this.estado,
    required this.cidade,
    required this.bairro,
    required this.endereco,
    required this.ultimaAtualizacao,
  });
}
