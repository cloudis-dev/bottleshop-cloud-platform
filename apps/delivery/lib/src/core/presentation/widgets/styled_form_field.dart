// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//
import 'package:delivery/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class StyledFormField extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final TextStyle? style;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onSaved;
  final TextEditingController? controller;
  final AutovalidateMode autovalidateMode;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final bool autoFocus;
  final bool readOnly;
  final bool enabled;

  const StyledFormField({Key? key,
    required this.onSaved,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.initialValue,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.decoration,
    this.style,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.autoFocus = false,
    this.readOnly = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autoFocus,
      cursorColor: Theme.of(context).colorScheme.secondary,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      initialValue: initialValue,
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
    );
  }
}

InputDecoration getInputFieldDecorator(
    {required BuildContext context,
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon}) {
  return InputDecoration(
    hintText: hintText,
    labelText: labelText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
  );
}

MultiValidator createPasswordValidator(BuildContext context) {
  return MultiValidator([
    RequiredValidator(errorText: S.of(context).passwordIsRequired),
    MinLengthValidator(6,
        errorText: S.of(context).passwordMinimumRequirementsHint),
  ]);
}

MultiValidator createEmailValidator(BuildContext context) {
  return MultiValidator([
    RequiredValidator(errorText: S.of(context).emailIsRequired),
    EmailValidator(errorText: S.of(context).enterAValidEmail),
  ]);
}
