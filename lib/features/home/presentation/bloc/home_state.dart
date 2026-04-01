import 'package:log_aqua_app/core/models/client_model.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitialState extends HomeState {
  const HomeInitialState();
}

class HomeStateLoading extends HomeState {
  const HomeStateLoading();
}

class HomeStateLoadedAll extends HomeState {
  final List<ClientModel> listaCliente;
  const HomeStateLoadedAll(this.listaCliente);
}

class HomeStateErroMessage extends HomeState {
  final String message;
  const HomeStateErroMessage(this.message);
}

class HomeStateSuccessMessage extends HomeState {
  final String message;
  const HomeStateSuccessMessage(this.message);
}
