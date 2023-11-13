import 'package:flutter/material.dart';

class Custom_Form_Field extends StatelessWidget {
  const Custom_Form_Field({
    super.key,
    this.label,
    this.icon,
    this.initialValue,
    this.validator,
    this.onsaved,
    this.textinputaction,
  });

  final label;
  final icon;
  final initialValue;
  final validator;
  final onsaved;
  final textinputaction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(label: label, prefixIcon: icon),
      textInputAction: textinputaction,
      validator: validator,
      onSaved: onsaved,
      initialValue: initialValue,
    );
  }
}
