import 'package:e_commerceapp/constant.dart';
import 'package:flutter/material.dart';

class CustomTextformfield extends StatelessWidget {
  const CustomTextformfield({
    super.key,
    required TextEditingController emailController,
    required this.validator,
    required this.obsecureText,
    required this.labelText,
    required this.keyboardType,
  }) : _emailController = emailController;

  final TextEditingController _emailController;
  final String? Function(String?)? validator;
  final bool obsecureText;
  final String labelText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      style:
          TextStyle(color: BaseColors.primary, decoration: TextDecoration.none),
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: BaseColors.primary, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          labelText: labelText,
          labelStyle: TextStyle(color: BaseColors.primary)),
      keyboardType: keyboardType,
      obscureText: obsecureText,
      validator: validator,
    );
  }
}
