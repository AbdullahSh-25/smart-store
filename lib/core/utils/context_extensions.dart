import 'package:flutter/material.dart';

extension SizeExt on BuildContext {
  double get fullHeight => MediaQuery.of(this).size.height;

  double get fullWidth => MediaQuery.of(this).size.width;
}

extension NavigationExt on BuildContext {
  Future<T?> push<T>(Widget screen, {String? name}) {
    return Navigator.push(
      this,
      MaterialPageRoute(
        settings: RouteSettings(name: name),
        builder: (context) {
          return screen;
        },
      ),
    );
  }

  Future<T?> pushReplacement<T>(Widget screen) {
    return Navigator.pushReplacement(
      this,
      MaterialPageRoute(
        builder: (context) {
          return screen;
        },
      ),
    );
  }
}


extension ThemeExt on BuildContext {
  Color get primaryColor => Theme.of(this).primaryColor;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
}