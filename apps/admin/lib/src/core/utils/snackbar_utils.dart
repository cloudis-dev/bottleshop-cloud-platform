import 'package:bottleshop_admin/src/core/result_message.dart';
import 'package:flutter/material.dart';

enum SnackBarDuration { long, short }

class SnackBarUtils {
  SnackBarUtils._();

  static const Map<SnackBarDuration, int> _durationToMs = {
    SnackBarDuration.short: 2000,
    SnackBarDuration.long: 3500,
  };

  static void showSnackBar(
    ScaffoldMessengerState messengerState,
    SnackBarDuration duration,
    String text, {
    SnackBarAction? action,
  }) {
    messengerState.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(milliseconds: _durationToMs[duration]!),
        action: action,
      ),
    );
  }

  static void showResultMessageSnackbar(
    ScaffoldMessengerState? messengerState,
    ResultMessage message,
  ) {
    SnackBarUtils.showSnackBar(
      messengerState!,
      SnackBarDuration.short,
      message.message,
    );
  }
}
