import 'package:flutter/material.dart';

class NonEditableTextField extends StatelessWidget {
  const NonEditableTextField({
    Key? key,
    required this.label,
    required this.ctrl,
    required this.modifiedHint,
    this.prefix,
  }) : super(key: key);

  final String label;
  final TextEditingController? ctrl;
  final String modifiedHint;
  final String? prefix;

  @override
  Widget build(BuildContext context) => AbsorbPointer(
        child: TextField(
          controller: ctrl,
          readOnly: true,
          style: const TextStyle(color: Colors.black54),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            labelStyle: const TextStyle(color: Colors.black54),
            labelText: label,
            filled: true,
            fillColor: Colors.black.withOpacity(.18),
            errorStyle: const TextStyle(color: Colors.black54),
            errorText: modifiedHint,
            prefixText: prefix,
          ),
        ),
      );
}
