import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:log_aqua_app/core/models/client_model.dart';
import 'package:log_aqua_app/features/clients/bloc/client_event.dart';
import 'package:log_aqua_app/features/clients/bloc/client_state.dart';
import 'package:log_aqua_app/features/clients/repository/cliente_repository.dart';
import 'package:sqflite/sqflite.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final Database database;
  final http.Client client;

  ClientBloc(this.database, this.client)
    : super(ClientInitialState()) {
    on<ClientEventLoadAll>((event, emit) async {
      emit(ClientStateLoading());
      try {
        final repository = ClienteRepository(database, client);
        final listaCliente = await repository.getAllClients();
        emit(ClientStateLoadedAll(listaCliente)); 
      } catch (e) {
        emit(ClientStateErroMessage('Erro ao carregar clientes: $e'));
      }
    });

    on<ClientEventAdd>((event, emit) async {
      emit(ClientStateLoading());
      try {
        final repository = ClienteRepository(database, client);
        await repository.addClient(event.cliente);
        emit(
          ClientStateSuccessMessage(
            'Cliente adicionado com sucesso.',
          ),
        );
        add(ClientEventLoadAll());
      } catch (e) {
        emit(ClientStateErroMessage('Erro ao adicionar cliente: $e'));
        add(ClientEventLoadAll());
      }
    });

    on<ClientEventUpdate>((event, emit) async {
      emit(ClientStateLoading());
      try {
        final repository = ClienteRepository(database, client);
        ClientModel cliente = await repository.updateClient(
          event.cliente,
        );
        emit(
          ClientStateSuccessMessage(
            'Cliente atualizado com sucesso.',
          ),
        );
        emit(ClientStateEditedClient(cliente));
        add(ClientEventLoadAll());
      } catch (e) {
        emit(
          ClientStateErroMessageUpdatedClient(
            'Erro ao atualizar cliente: $e',
          ),
        );
        add(ClientEventLoadAll());
      }
    });

    on<ClientEventDelete>((event, emit) async {
      emit(ClientStateLoading());
      try {
        final repository = ClienteRepository(database, client);
        await repository.removeClient(event.cliente);
        emit(
          ClientStateSuccessMessage('Cliente removido com sucesso.'),
        );
        add(ClientEventLoadAll());
      } catch (e) {
        emit(ClientStateErroMessage('Erro ao remover cliente: $e'));
        add(ClientEventLoadAll());
      }
    });

    on<ClientEventSearchCEP>((event, emit) async {
      emit(ClientStateLoading());
      try {
        final repository = ClienteRepository(database, client);
        final searchMap = await repository.viaCepApi(event.cep);
        if (searchMap.containsKey('erro')) {
          emit(ClientStateErroMessageSearchCEP(searchMap['erro']));
        } else {
          emit(
            ClientStateSuccessMessage(
              'Dados do CEP encontrados com sucesso',
            ),
          );
        }
        emit(ClientStateSearchCEP(searchMap));
        add(ClientEventLoadAll());
      } catch (e) {
        emit(ClientStateErroMessage('Erro ao fazer consulta $e'));
        add(ClientEventLoadAll());
      }
    });
  }
}
