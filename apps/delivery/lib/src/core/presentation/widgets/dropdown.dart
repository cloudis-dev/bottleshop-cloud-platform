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

enum DropDownType {
  formField,
  popUpMenu,
  button,
}

class DropDown<T> extends StatefulWidget {
  final DropDownType dropDownType;
  final List<T> items;

  /// If needs to render custom widgets for dropdown items must provide values for customWidgets
  /// Also the customWidgets length have to be equals to items
  final List<Widget> customWidgets;
  final T initialValue;
  final Widget? hint;
  final void Function(T? value)? onChanged;
  final bool isExpanded;

  /// If need to clear dropdown currently selected value
  final bool isCleared;

  /// You can choose between show an underline at bottom or not
  final bool showUnderline;

  const DropDown({
    super.key,
    this.dropDownType = DropDownType.button,
    required this.items,
    required this.customWidgets,
    required this.initialValue,
    this.hint,
    required this.onChanged,
    this.isExpanded = false,
    this.isCleared = false,
    this.showUnderline = true,
  })  : assert(items is! Widget),
        assert(items.length == customWidgets.length);

  @override
  // ignore: library_private_types_in_public_api
  _DropDownState<T> createState() => _DropDownState();
}

class _DropDownState<T> extends State<DropDown<T>> {
  T? selectedValue;

  @override
  void initState() {
    selectedValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget dropdown;

    switch (widget.dropDownType) {
      case DropDownType.formField:
        dropdown = const SizedBox();
        break;
      case DropDownType.popUpMenu:
        dropdown = const SizedBox();
        break;
      // case DropDownType.Button: // Empty statement
      default:
        dropdown = DropdownButton<T>(
          isExpanded: widget.isExpanded,
          onChanged: (value) {
            setState(() => selectedValue = value);
            widget.onChanged?.call(value);
          },
          value: widget.isCleared ? null : selectedValue,
          items: widget.items.map<DropdownMenuItem<T>>(buildDropDownItem).toList(),
          hint: widget.hint,
        );
    }

    // Wrapping Dropdown in DropdownButtonHideUnderline removes the underline

    return widget.showUnderline ? dropdown : DropdownButtonHideUnderline(child: dropdown);
  }

  DropdownMenuItem<T> buildDropDownItem(T item) => DropdownMenuItem<T>(
        value: item,
        child: widget.customWidgets[widget.items.indexOf(item)],
      );
}
