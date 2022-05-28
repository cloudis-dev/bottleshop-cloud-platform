import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool shouldUseMobileLayout(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  return !kIsWeb || width < 600;
}
