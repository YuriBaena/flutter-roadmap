import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool ocultar;
  final String? Function(String?)? validator;

  const TextInput({
    super.key,
    required this.label,
    this.controller,
    this.ocultar = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child:
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: TextFormField(
            controller: this.controller,
            obscureText: this.ocultar,
            validator: this.validator,
            decoration: InputDecoration(
              labelText: this.label,
            ),
          ),
        ),
    );
  }
}