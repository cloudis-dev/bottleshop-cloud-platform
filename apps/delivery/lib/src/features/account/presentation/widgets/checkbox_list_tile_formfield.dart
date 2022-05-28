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

import 'package:flutter/material.dart';

class CheckboxListTileFormField extends FormField<bool> {
  CheckboxListTileFormField({
    Key? key,
    Widget? title,
    BuildContext? context,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    bool dense = true,
    Color? errorColor,
    Color? activeColor,
    Color? checkColor,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.leading,
    Widget? secondary,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (state) {
            errorColor ??= (context == null ? Colors.red : Theme.of(context).errorColor);

            return CheckboxListTile(
              contentPadding: EdgeInsetsDirectional.zero,
              title: title,
              dense: dense,
              activeColor: activeColor,
              checkColor: checkColor,
              value: state.value,
              onChanged: enabled ? state.didChange : null,
              subtitle: state.hasError
                  ? Text(
                      state.errorText!,
                      style: TextStyle(color: errorColor),
                    )
                  : null,
              controlAffinity: controlAffinity,
              secondary: secondary,
            );
          },
        );
}
