import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, message, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      duration: Duration(seconds: 1),
      content: Text(message),
    ),
  );
}
