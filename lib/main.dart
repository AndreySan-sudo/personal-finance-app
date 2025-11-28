import 'package:finances_app/app/finances_app.dart';
import 'package:finances_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDependencies();
  print("Firebase.apps.length: ${Firebase.apps.length}");

  runApp(const FinancesApp());
}
