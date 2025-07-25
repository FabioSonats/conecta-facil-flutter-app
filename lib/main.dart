import 'package:conecta_facil/app/di/injector.dart';
import 'package:conecta_facil/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
// import 'firebase_options.dart'; // Gerado pelo CLI do Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupInjector();
  runApp(const App());
}
