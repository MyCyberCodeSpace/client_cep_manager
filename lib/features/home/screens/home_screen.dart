import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_aqua_app/core/ui_helpers/main_alert_dialog.dart';
import 'package:log_aqua_app/core/ui_helpers/main_snackbar_helper.dart';
import 'package:log_aqua_app/core/widgets/main_bottom_sheet.dart';
import 'package:log_aqua_app/core/widgets/main_circular_progress.dart';
import 'package:log_aqua_app/core/widgets/main_suporte.dart';
import 'package:log_aqua_app/features/clients/bloc/client_bloc.dart';
import 'package:log_aqua_app/features/clients/bloc/client_event.dart';
import 'package:log_aqua_app/features/clients/bloc/client_state.dart';
import 'package:log_aqua_app/features/clients/screens/clients_screen.dart';
import 'package:log_aqua_app/features/home/widgets/text_last_updated.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ClientBloc clientBloc;

  @override
  void initState() {
    super.initState();
    clientBloc = context.read<ClientBloc>();
    clientBloc.add(ClientEventLoadAll());
  }

  void openClientList() {
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.fade,
        childBuilder: (ctx) => ClientsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;

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
            body: Padding(
              padding: EdgeInsetsGeometry.only(
                top: 100,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, MJ',
                    style: TextStyle(
                      fontSize: Theme.of(
                        context,
                      ).textTheme.displayLarge!.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: currentHeight * 0.02),
                  state.listaCliente.isNotEmpty
                      ? TextLastUpdated(
                          text:
                              'Última atualização: ${state.listaCliente[0].ultimaAtualizacao}',
                        )
                      : TextLastUpdated(
                          text:
                              'Adicione alguns clientes a sua base de dados :',
                        ),
                  GestureDetector(
                    onTap: () {
                      openClientList();
                    },
                    child: Card(
                      color: const Color.fromARGB(248, 255, 255, 250),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: currentHeight * 0.03,
                          horizontal: currentWidth * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                'assets/app/icon_people_custom.png',
                                height: currentHeight * 0.10,
                              ),
                            ),
                            SizedBox(width: currentWidth * 0.06),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Transform.translate(
                                    offset: Offset(
                                      0,
                                      -currentHeight * 0.001,
                                    ),
                                    child: Text(
                                      state.listaCliente.length
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: "Righteous",
                                        fontSize: currentWidth * 0.2,
                                        fontWeight: FontWeight.bold,
                                        height: 1.0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),

                                  Transform.translate(
                                    offset: Offset(
                                      0,
                                      currentHeight * -0.005,
                                    ),
                                    child: Text(
                                      'Clientes',
                                      style: TextStyle(
                                        fontFamily: "Righteous",
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .fontSize,
                                        fontWeight: FontWeight.bold,
                                        height: 1.0,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
