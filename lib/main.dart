import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:log_aqua_app/core/data/initial_client_data.dart';
import 'package:log_aqua_app/features/clients/bloc/client_bloc.dart';
import 'package:log_aqua_app/features/login/screens/login_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await openDatabase(
    p.join(await getDatabasesPath(), 'just_user_focus.db'),
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE clientes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nomeCompleto TEXT NOT NULL,
          cep INTEGER NOT NULL,
          estado TEXT NOT NULL,
          cidade TEXT NOT NULL,
          bairro TEXT NOT NULL,
          endereco TEXT NOT NULL,
          ultimaAtualizacao TEXT NOT NULL
        );
      ''');
      for (var cliente in listaClientes) {
        await db.insert('clientes', {
          'nomeCompleto': cliente.nomeCompleto,
          'cep': cliente.cep,
          'estado': cliente.estado,
          'cidade': cliente.cidade,
          'bairro': cliente.bairro,
          'endereco': cliente.endereco,
          'ultimaAtualizacao': cliente.ultimaAtualizacao,
        });
      }
    },
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(
      BlocProvider(
        create: (context) => ClientBloc(database, http.Client()),
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3C94A0),
    ).copyWith(primary: const Color(0xFF3C94A0));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      home: LoginScreen(),
    );
  }
}
