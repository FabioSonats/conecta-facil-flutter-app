import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/app.dart';
import 'app/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração do Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupInjector();
  runApp(const App());
}
