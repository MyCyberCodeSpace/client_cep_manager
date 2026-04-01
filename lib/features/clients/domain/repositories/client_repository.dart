import 'package:log_aqua_app/core/models/client_model.dart';
import 'package:log_aqua_app/features/clients/domain/typedefs/client_typedefs.dart';

abstract class ClientRepository {
  FutureClientList getAllClients();
  FutureVoid addClient(ClientModel cliente);
  FutureClient updateClient(ClientModel cliente);
  FutureInt removeClient(ClientModel cliente);
  FutureCepData searchCEP(int cep);
}
