import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_aqua_app/core/models/client_model.dart';
import 'package:log_aqua_app/core/ui_helpers/main_alert_dialog.dart';
import 'package:log_aqua_app/core/ui_helpers/main_snackbar_helper.dart';
import 'package:log_aqua_app/core/widgets/main_app_bar.dart';
import 'package:log_aqua_app/core/widgets/main_bottom_sheet.dart';
import 'package:log_aqua_app/core/widgets/main_circular_progress.dart';
import 'package:log_aqua_app/core/widgets/main_suporte.dart';
import 'package:log_aqua_app/features/clients/bloc/client_bloc.dart';
import 'package:log_aqua_app/features/clients/bloc/client_event.dart';
import 'package:log_aqua_app/features/clients/bloc/client_state.dart';
import 'package:log_aqua_app/features/clients/screens/edit_clients_screen.dart';
import 'package:log_aqua_app/features/clients/screens/new_client_screen.dart';
import 'package:page_transition/page_transition.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  late ClientBloc clientBloc;

  @override
  void initState() {
    super.initState();
    clientBloc = context.read<ClientBloc>();
    clientBloc.add(ClientEventLoadAll());
  }

  void openEditClient(ClientModel cliente) {
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.fade,
        childBuilder: (ctx) => EditClientsScreen(cliente: cliente),
      ),
    );
  }

  void openAddClient() {
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.fade,
        childBuilder: (ctx) => NewClientScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;

    return BlocConsumer<ClientBloc, ClientState>(
      listener: (context, state) {
        if (state is ClientStateErroMessage) {
          showMyDialog(context, 'Opps..', state.message);
        } else if (state is ClientStateSuccessMessage) {
          showMainSnackBar(context, state.message);
        }
      },

      builder: (context, state) {
        if (state is ClientStateLoading) {
          return Scaffold(
            body: MainCircularProgress(),
            bottomSheet: mainBottomSheet(),
          );
        } else if (state is ClientStateLoadedAll) {
          return Scaffold(
            appBar: mainAppBar(context: context, text: 'Clientes'),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.all(currentHeight * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registros (${state.listaCliente.length})',
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary,
                          ),
                    ),
                    SizedBox(height: currentHeight * 0.02),
                    SizedBox(
                      height: currentHeight * 0.4,
                      child: state.listaCliente.isEmpty
                          ? Text(
                              'Adicione alguns clientes a sua lista :D\nBasta clicar no botão abaixo....',
                            )
                          : SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.listaCliente.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      openEditClient(
                                        state.listaCliente[index],
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(
                                                currentHeight * 0.01,
                                              ),
                                              child: Image.asset(
                                                'assets/app/icon_people_custom.png',
                                                height:
                                                    currentHeight *
                                                    0.07,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                state
                                                    .listaCliente[index]
                                                    .nomeCompleto,
                                                style: TextStyle(
                                                  fontFamily:
                                                      "Montserrat",
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontSize:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .fontSize,
                                                ),
                                                overflow: TextOverflow
                                                    .ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 2,
                                          height: 10,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.1),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                    SizedBox(height: currentHeight * 0.1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            openAddClient();
                          },
                          child: Text('Incluir novo cliente'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomSheet: mainBottomSheet(),
          );
        }
        return MainSuporte();
      },
    );
  }
}
