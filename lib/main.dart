import 'package:flutter/material.dart';
import 'package:cryptomarket/navigation/app_router.dart';
import 'package:cryptomarket/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CryptoScopeApp());
}

class CryptoScopeApp extends StatelessWidget {
  const CryptoScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CryptoScope',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
