import 'package:flutter/material.dart';
import 'package:log_aqua_app/core/models/client_model.dart';
import 'package:log_aqua_app/core/widgets/main_app_bar.dart';
import 'package:log_aqua_app/features/clients/widgets/cliente_form.dart';

class EditClientsScreen extends StatelessWidget {
  final ClientModel cliente;
  const EditClientsScreen({required this.cliente, super.key});
  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: mainAppBar(
        context: context,
        text: cliente.nomeCompleto,
      ),
      body: Padding(
        padding: EdgeInsets.all(currentHeight * 0.03),
        child: ClientForm(client: cliente),
      ),
    );
  }
}
