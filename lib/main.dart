import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_store/config/color_scheme/light_color_scheme.dart';
import 'package:smart_store/screens/login_screen.dart';

import 'core/constants/app_keys.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(AppKeys.box);
  debugPrint(Hive.box(AppKeys.box).get(AppKeys.token));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'tajwal',
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      builder: (context, child) {
        child = BotToastInit()(context, child!);
        return Directionality(textDirection: TextDirection.rtl, child: child);
      },
      home: const LoginScreen(),
    );
  }
}
