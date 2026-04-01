import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_aqua_app/features/home/presentation/bloc/home_event.dart';
import 'package:log_aqua_app/features/home/presentation/bloc/home_state.dart';
import 'package:log_aqua_app/features/home/domain/repositories/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(const HomeInitialState()) {
    on<HomeEventLoadAllUsers>((event, emit) async {
      emit(const HomeStateLoading());
      try {
        final listaCliente = await repository.getAllUsers();
        emit(HomeStateLoadedAll(listaCliente));
      } catch (e) {
        emit(HomeStateErroMessage('Erro ao carregar usuários: $e'));
      }
    });
  }
}
