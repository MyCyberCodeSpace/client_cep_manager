import 'package:flutter/material.dart';
import 'package:log_aqua_app/features/home/presentation/screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';

class LoginController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _enteredEmail = '';
  String _enteredPassword = '';

  String get enteredEmail => _enteredEmail;
  String get enteredPassword => _enteredPassword;

  void setEmail(String value) {
    _enteredEmail = value;
  }

  void setPassword(String value) {
    _enteredPassword = value;
  }

  void submit(BuildContext context) {
    final isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      formKey.currentState!.save();
      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.fade,
          childBuilder: (ctx) => HomeScreen(),
        ),
      );
    }
  }
}
