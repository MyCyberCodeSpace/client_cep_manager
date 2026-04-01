import 'package:flutter/material.dart';
import 'package:log_aqua_app/features/clients/presentation/screens/clients_screen.dart';
import 'package:page_transition/page_transition.dart';

class HomeController {
  void openClientList(BuildContext context) {
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.fade,
        childBuilder: (ctx) => const ClientsScreen(),
      ),
    );
  }
}
