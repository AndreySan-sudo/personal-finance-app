import 'package:flutter/material.dart';
import 'router/app_router.dart';

class FinancesApp extends StatelessWidget {
  const FinancesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter().router,
    );
  }
}
