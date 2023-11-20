import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:flutter/material.dart';

class ActiveTextField extends StatelessWidget {
  const ActiveTextField({
    super.key,
    required this.label,
    required this.ctrl,
    required this.onSaved,
    this.validator,
    this.suffix,
    this.prefix,
    this.keyboardType,
    this.minLines,
    this.maxLines,
  });

  final String? Function(String?)? validator;
  final void Function(String?) onSaved;
  final String? suffix;
  final String? prefix;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final TextEditingController? ctrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    final fieldKey = GlobalKey<FormFieldState>();

    return TextFormField(
      key: fieldKey,
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: AutovalidateMode.disabled,
      onChanged: (_) {
        if (fieldKey.currentState?.validate() ?? false) {
          fieldKey.currentState?.save();
        }
      },
      style: const TextStyle(color: Colors.black),
      controller: ctrl,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppTheme.lightGreySolid,
        suffixText: suffix,
        prefixText: prefix,
      ),
    );
  }
}
