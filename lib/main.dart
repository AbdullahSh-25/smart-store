import 'package:flutter/material.dart';
import 'package:smart_store/config/color_scheme/light_color_scheme.dart';
import 'package:smart_store/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Store',
      theme: ThemeData(
        fontFamily: 'tajwal',
        colorScheme:  lightColorScheme,
        useMaterial3: true,
      ),
      builder: (context,child){
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const LoginScreen(),
    );
  }
}

