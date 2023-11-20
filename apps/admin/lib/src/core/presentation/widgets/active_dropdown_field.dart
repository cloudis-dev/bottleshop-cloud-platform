import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:flutter/material.dart';

class ActiveDropdownField<T> extends StatelessWidget {
  const ActiveDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.currentValue,
    required this.onSaved,
    this.validator,
    this.validateInitially,
  });

  final bool? validateInitially;
  final String label;
  final T? currentValue;
  final List<DropdownMenuItem<T>> items;
  final String? Function(T?)? validator;
  final void Function(T?) onSaved;

  @override
  Widget build(BuildContext context) {
    final fieldKey = GlobalKey<FormFieldState<dynamic>>();

    if (validateInitially ?? false) {
      Future.microtask(() => fieldKey.currentState?.validate());
    }

    return DropdownButtonFormField<T>(
      key: fieldKey,
      validator: validator,
      value: currentValue,
      items: items,
      onChanged: (_) {
        if (fieldKey.currentState?.validate() ?? false) {
          fieldKey.currentState?.save();
        }
      },
      onSaved: onSaved,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppTheme.lightGreySolid,
      ),
    );
  }
}
