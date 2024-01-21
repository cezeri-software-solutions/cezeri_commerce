import 'package:cezeri_commerce/injection.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '2_application/firebase/auth/auth_bloc/auth_bloc.dart';
import '2_application/firebase/main_settings/main_settings_bloc.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'routes/router.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()..add(AuthCheckRequestedEvent())),
        BlocProvider(create: (context) => sl<MainSettingsBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        builder: (context, child) {
          return ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 699, name: MOBILE),
              const Breakpoint(start: 700, end: 1399, name: TABLET),
              const Breakpoint(start: 1400, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          );
        },
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('de', 'DE')],
      ),
    );
  }
}
