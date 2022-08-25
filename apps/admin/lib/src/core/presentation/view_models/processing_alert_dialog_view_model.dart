import 'package:flutter/material.dart';

class ProcessingAlertDialogViewModel extends ChangeNotifier {
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  set isProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }
}
