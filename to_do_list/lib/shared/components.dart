import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  Function(String)? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  bool isPassword = false,
  IconData? suffix,
  Function()? suffixPressed,
  String? Function(String?)? validate,
  bool isClickable = true,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    onFieldSubmitted: onSubmit,
    onChanged: onChange,
    onTap: onTap,
    enabled: isClickable,
    validator: validate,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: suffix != null
          ? IconButton(icon: Icon(suffix), onPressed: suffixPressed)
          : null,
      border: const OutlineInputBorder(),
    ),
  );
}
