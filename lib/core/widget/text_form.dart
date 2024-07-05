import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.label,
      this.validate,
      this.isPassword = false,
      this.icon,
      this.prefixIcon,
      required this.onpressed});
  final String hintText;
  final TextEditingController controller;
  final String label;
  final Icon? prefixIcon;
  final String? Function(String?)? validate;
  final bool isPassword;
  final IconData? icon;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: const Color(0xff447055),
      controller: controller,
      validator: validate,
      obscureText: isPassword,
      decoration: InputDecoration(
          focusColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.white),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: IconButton(
              onPressed: onpressed,
              icon: Icon(
                icon,
                color: Color.fromARGB(255, 110, 187, 168),
              )),
          hintText: hintText,
          labelText: label),
    );
  }
}
