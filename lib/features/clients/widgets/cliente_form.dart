import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_aqua_app/core/models/client_model.dart';
import 'package:log_aqua_app/core/ui_helpers/main_alert_dialog.dart';
import 'package:log_aqua_app/core/ui_helpers/main_snackbar_helper.dart';
import 'package:log_aqua_app/core/widgets/main_bottom_sheet.dart';
import 'package:log_aqua_app/core/widgets/main_circular_progress.dart';
import 'package:log_aqua_app/features/clients/bloc/client_bloc.dart';
import 'package:log_aqua_app/features/clients/bloc/client_event.dart';
import 'package:log_aqua_app/features/clients/bloc/client_state.dart';
import 'package:log_aqua_app/features/clients/widgets/form_custom_spacer.dart';
import 'package:log_aqua_app/features/clients/widgets/form_input_decoration.dart';
import 'package:log_aqua_app/features/clients/widgets/form_input_decoration_hint.dart';
import 'package:log_aqua_app/features/clients/widgets/form_text_entry_indicator.dart';
import 'package:log_aqua_app/features/clients/widgets/form_main_buttons.dart';

class ClientForm extends StatefulWidget {
  final ClientModel? client;
  const ClientForm({super.key, this.client});

  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _cepController;
  late TextEditingController _estadoController;
  late TextEditingController _cidadeController;
  late TextEditingController _bairroController;
  late TextEditingController _enderecoController;
  late ClientBloc clientBloc;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(
      text: widget.client?.nomeCompleto ?? '',
    );
    _cepController = TextEditingController(
      text: widget.client?.cep.toString() ?? '',
    );
    _estadoController = TextEditingController(
      text: widget.client?.estado ?? '',
    );
    _cidadeController = TextEditingController(
      text: widget.client?.cidade ?? '',
    );
    _bairroController = TextEditingController(
      text: widget.client?.bairro ?? '',
    );
    _enderecoController = TextEditingController(
      text: widget.client?.endereco ?? '',
    );
    clientBloc = context.read<ClientBloc>();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cepController.dispose();
    _estadoController.dispose();
    _cidadeController.dispose();
    _bairroController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  void _editarCliente() {
    if (_formKey.currentState!.validate()) {
      final cliente = ClientModel(
        id: widget.client!.id,
        nomeCompleto: _nomeController.text,
        cep: int.parse(_cepController.text),
        estado: _estadoController.text,
        cidade: _cidadeController.text,
        bairro: _bairroController.text,
        endereco: _enderecoController.text,
        ultimaAtualizacao: DateTime.now().toIso8601String(),
      );
      clientBloc.add(ClientEventUpdate(cliente));
    }
  }

  void _buscarCliente() {
    final cep = _cepController.text.trim();

    if (cep.length != 8 || int.tryParse(cep) == null) {
      showMyDialog(
        context,
        'CEP inválido',
        'O CEP deve ter exatamente 8 números.',
      );
      return;
    }
    clientBloc.add(ClientEventSearchCEP(int.parse(cep)));
  }

  void _excluirCliente() {
    clientBloc.add(ClientEventDelete(widget.client!));
    Navigator.of(context).pop();
  }

  void _salvarCliente() {
    if (_formKey.currentState!.validate()) {
      final cliente = ClientModel(
        nomeCompleto: _nomeController.text,
        cep: int.parse(_cepController.text),
        estado: _estadoController.text,
        cidade: _cidadeController.text,
        bairro: _bairroController.text,
        endereco: _enderecoController.text,
        ultimaAtualizacao: DateTime.now().toIso8601String(),
      );
      clientBloc.add(ClientEventAdd(cliente));
    }
  }

  Widget _buildButtons() {
    if (widget.client == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FormMainButtons(
            function: _salvarCliente,
            text: 'Salvar',
            isMainButton: true,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FormMainButtons(
            function: _excluirCliente,
            text: 'Excluir',
            isMainButton: false,
          ),

          FormMainButtons(
            function: _editarCliente,
            text: 'Atualizar',
            isMainButton: true,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return BlocConsumer<ClientBloc, ClientState>(
      listener: (context, state) {
        if (state is ClientStateSearchCEP) {
          final dados = state.searchMap;
          _estadoController.text = dados['estado'] ?? '';
          _cidadeController.text = dados['cidade'] ?? '';
          _bairroController.text = dados['bairro'] ?? '';
          _enderecoController.text = dados['endereco'] ?? '';
        } else if (state is ClientStateEditedClient) {
          _estadoController.text = state.cliente.estado;
          _cidadeController.text = state.cliente.cidade;
          _bairroController.text = state.cliente.bairro;
          _enderecoController.text = state.cliente.endereco;
        } else if (state is ClientStateErroMessageUpdatedClient) {
          showMyDialog(context, 'Opps..', state.message);
        } else if (state is ClientStateSuccessMessage) {
          showMainSnackBar(context, state.message);
        } else if (state is ClientStateErroMessageSearchCEP) {
          showMainSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ClientStateLoading) {
          return Scaffold(body: MainCircularProgress());
        }
        return Form(
          key: _formKey,
          child: ListView(
            children: [
              const FormTextEntryIndicator(text: 'Nome completo'),
              TextFormField(
                controller: _nomeController,
                style: formInputDecoration(context: context),
                decoration: formInputDecorationHint(
                  context: context,
                  text: 'Nome completo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),

              const FormCustomSpacer(),
              const FormTextEntryIndicator(text: 'CEP'),
              TextFormField(
                controller: _cepController,
                style: formInputDecoration(context: context),
                decoration: formInputDecorationHint(
                  context: context,
                  text: 'Informe o CEP para atualizar o endereço',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CEP';
                  }
                  if (int.tryParse(value) == null) {
                    return 'CEP deve ser um número';
                  }
                  return null;
                },

                onChanged: (value) {
                  if (value.length == 8) {
                    _buscarCliente();
                  }
                },
              ),
              const FormCustomSpacer(),

              FormTextEntryIndicator(text: 'Estado'),
              TextFormField(
                controller: _estadoController,
                style: formInputDecoration(context: context),
                decoration: formInputDecorationHint(
                  context: context,
                  text: 'Informe o estado',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o estado';
                  }
                  return null;
                },
              ),
              const FormCustomSpacer(),

              FormTextEntryIndicator(text: 'Cidade'),
              TextFormField(
                controller: _cidadeController,
                style: formInputDecoration(context: context),
                decoration: formInputDecorationHint(
                  context: context,
                  text: 'Informe o cidade',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a cidade';
                  }
                  return null;
                },
              ),
              const FormCustomSpacer(),

              FormTextEntryIndicator(text: 'Bairro'),
              TextFormField(
                controller: _bairroController,
                style: formInputDecoration(context: context),
                decoration: formInputDecorationHint(
                  context: context,
                  text: 'Informe o bairro',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o bairro';
                  }
                  return null;
                },
              ),
              const FormCustomSpacer(),
              const FormTextEntryIndicator(text: 'Endereço'),
              TextFormField(
                controller: _enderecoController,
                style: formInputDecoration(context: context),
                decoration: formInputDecorationHint(
                  context: context,
                  text: 'Informe o endereço',
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o endereço';
                  }
                  return null;
                },
              ),
              FormCustomSpacer(optionalHeight: currentHeight * 0.02),
              _buildButtons(),
              FormCustomSpacer(optionalHeight: currentHeight * 0.03),
              mainBottomSheet(),
            ],
          ),
        );
      },
    );
  }
}
