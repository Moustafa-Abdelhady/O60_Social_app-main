import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class CustomForTextField extends StatelessWidget {
  CustomForTextField({
    super.key,
    this.hintText,
    this.onChanged,
    this.obscureText = false,
  });

  Function(String)? onChanged;
  String? hintText;
  bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      validator: (data) {
        if (data!.isEmpty) {
          return 'filed is required';
        } else if (data.length < 3) {}
      },
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          )),
    );
  }
}
