import 'package:flutter/material.dart';

class MyPopUpMenuItem<T> extends PopupMenuItem<T> {
  MyPopUpMenuItem(
    Widget textContent,
    Icon icon,
    T value, [
    bool enabled = true,
  ]) : super(
          value: value,
          enabled: enabled,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: textContent,
                ),
              ),
              icon,
            ],
          ),
        );
}
