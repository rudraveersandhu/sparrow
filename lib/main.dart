import 'package:firebase_core/firebase_core.dart';

import 'package:sparrow_v1/pages/splash_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

late Size mq;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialiseFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sparrow',
      home: SplashPage(),
    );
  }
}

_initialiseFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}
