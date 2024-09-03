import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/injection.dart' as di;
import '2_application/database/auth/auth_bloc/auth_bloc.dart';
import '2_application/database/main_settings/main_settings_bloc.dart';
import 'injection.dart';
import 'routes/router.dart';
import 'themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 100));

  await Supabase.initialize(
    url: 'https://zpxmvushxwqsvoidfjeh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpweG12dXNoeHdxc3ZvaWRmamVoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTMyODk1NTcsImV4cCI6MjAyODg2NTU1N30.YIzAvITvgBRE5-8CGJ3diLh7K1pZA3xw7wQLDzJ3Qks',
  );
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
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
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
