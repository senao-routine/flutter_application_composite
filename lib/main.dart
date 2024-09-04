import 'package:composite_app/firebase_options.dart';
import 'package:composite_app/inputformview.dart';
import 'package:composite_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Talent Composite',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InputFormView(),
    );
  }
}
