import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

bool shouldUseMobileLayout(BuildContext context) {
  return !kIsWeb || ResponsiveWrapper.of(context).isMobile;
}
