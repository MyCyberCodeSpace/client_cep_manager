import 'package:log_aqua_app/core/models/client_model.dart';

abstract class ClientEvent {}

class ClientEventLoadAll extends ClientEvent{}

class ClientEventAdd extends ClientEvent {
  final ClientModel cliente;
  ClientEventAdd(this.cliente);
}

class ClientEventDelete extends ClientEvent {
  final ClientModel cliente;
  ClientEventDelete(this.cliente);
}

class ClientEventUpdate extends ClientEvent {
  final ClientModel cliente;
  ClientEventUpdate(this.cliente);
}

class ClientEventSearchCEP extends ClientEvent {
  final int cep;
  ClientEventSearchCEP(this.cep);
}
