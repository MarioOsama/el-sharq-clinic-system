import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  void pop() {
    Navigator.of(this).pop();
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String toId(int idLength, {String prefix = ''}) {
    return prefix + this.padLeft(idLength, '0');
  }

  String getNextId(int idLength, String prefix) {
    final int id = int.parse(this.replaceAll(prefix, ''));
    return (id + 1).toString().toId(idLength, prefix: prefix);
  }

  bool isPhoneNumber() {
    return RegExp(r"^\+?0[0-9]{10}$").hasMatch(this);
  }
}
