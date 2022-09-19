import 'package:flutter/material.dart';

class CustomTextHomeField extends StatelessWidget {
  CustomTextHomeField(
      {this.obscureText = false, this.onChanged, this.hintText});
  bool? obscureText = false;
  String? hintText;
  void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      onChanged: onChanged,
      validator: ((value) {
        if (value!.isEmpty) {
          return 'this field is required';
        }
      }),
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white))),
    );
  }
}
