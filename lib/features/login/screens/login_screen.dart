import 'package:flutter/material.dart';
import 'package:log_aqua_app/features/login/widgets/login_input_decoration.dart';
import 'package:log_aqua_app/features/home/screens/home_screen.dart';
import 'package:log_aqua_app/features/login/widgets/form_item_names.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // ignore: unused_field
  var _enteredEmail = '';
  // ignore: unused_field
  var _enteredPassword = '';

  void _submit() {
    final isValidForm = _formKey.currentState!.validate();
    if (isValidForm) {
      _formKey.currentState!.save();
      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.fade,
          childBuilder: (ctx) => HomeScreen(),
        ),
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 255, 255, 250),
      body: Padding(
        padding: EdgeInsets.all(currentHeight * 0.03),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/app/logo_and_name.png'),
                    height: currentHeight * 0.15,
                  ),
                ],
              ),
              SizedBox(height: 50),
              Text(
                'Entre com sua conta',
                style: TextStyle(
                  fontSize: Theme.of(
                    context,
                  ).textTheme.titleLarge!.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              SizedBox(height: currentHeight * 0.015),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormItemNames(text: 'Email'),
                    TextFormField(
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.fontSize,
                      ),
                      decoration: loginInputDecoration(
                        context: context,
                        text: 'Email de acesso',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Insira um email valido';
                        }
                        return null;
                      },
                      onSaved: (newValue) =>
                          _enteredEmail = newValue!,
                    ),
                    SizedBox(height: currentHeight * 0.015),

                    FormItemNames(text: 'Senha'),
                    TextFormField(
                      decoration: loginInputDecoration(
                        context: context,
                        text: '******',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null ||
                            value.trim().length < 6) {
                          return 'A senha precisa ser de pelo menos 6 caracteres';
                        }
                        return null;
                      },
                      onSaved: (newValue) =>
                          _enteredPassword = newValue!,
                    ),
                    SizedBox(height: currentHeight * 0.040),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _submit,
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLowest,
                          ),
                        ),
                        SizedBox(width: 30),
                        Icon(
                          Icons.double_arrow,
                          size: 30,
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLowest,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
