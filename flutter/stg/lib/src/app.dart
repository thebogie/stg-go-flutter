import 'package:flutter/material.dart';
import 'screens/loginscreen.dart';

class App extends StatelessWidget {
  build(context) {
    return MaterialApp(
        title: 'Smack Talk Gaming', home: Scaffold(body: LoginScreen()));
  }
}
