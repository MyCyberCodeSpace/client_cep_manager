import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:log_aqua_app/core/config/service_locator.dart';
import 'package:log_aqua_app/features/login/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await ServiceLocator.setupDependencies();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF3C94A0),
    ).copyWith(primary: const Color(0xFF3C94A0));

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ServiceLocator.getClientBloc()),
        BlocProvider(create: (_) => ServiceLocator.getHomeBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: colorScheme,
          scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent,
          ),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
