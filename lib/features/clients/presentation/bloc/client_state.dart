import 'package:log_aqua_app/core/models/client_model.dart';

abstract class ClientState {}

class ClientInitialState extends ClientState {}

class ClientStateLoading extends ClientState {}

class ClientStateSearchCEP extends ClientState {
  final Map<String, dynamic> searchMap;
  ClientStateSearchCEP(this.searchMap);
}

class ClientStateErroMessageSearchCEP extends ClientState {
  final String message;
  ClientStateErroMessageSearchCEP(this.message);
}

class ClientStateLoadedAll extends ClientState {
  final List<ClientModel> listaCliente;
  ClientStateLoadedAll(this.listaCliente);
}

class ClientStateErroMessage extends ClientState {
  final String message;
  ClientStateErroMessage(this.message);
}

class ClientStateEditedClient extends ClientState {
  final ClientModel cliente;
  ClientStateEditedClient(this.cliente);
}

class ClientStateErroMessageUpdatedClient extends ClientState {
  final String message;
  ClientStateErroMessageUpdatedClient(this.message);
}

class ClientStateSuccessMessage extends ClientState {
  final String message;
  ClientStateSuccessMessage(this.message);
}
