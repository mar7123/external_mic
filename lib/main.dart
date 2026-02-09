import 'package:easy_localization/easy_localization.dart';
import 'package:external_mic/navigation/main_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  for (RenderView renderView in widgetsBinding.renderViews) {
    renderView.automaticSystemUiAdjustment = false;
  }

  GoRouter.optionURLReflectsImperativeAPIs = true;
  GoRouter router = MainNavigator().initialize();
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale("en", "US"), Locale("id", "")],
        path: "assets/string",
        fallbackLocale: const Locale("en", ""),
        useOnlyLangCode: true,
        child: MainApp(router: router),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  final GoRouter router;

  const MainApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "External Mic",
      routerConfig: router,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => child!,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF183E4B),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
