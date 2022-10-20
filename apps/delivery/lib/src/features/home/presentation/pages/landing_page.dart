import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import '../widgets/landing/footer.dart';
import '../widgets/landing/header.dart';


class Landing extends StatelessWidget {
  const Landing({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper.builder(
          Column(
      children: [
        Header(),
        Footer(),
      ],
       ),
          maxWidth: 1920,
          minWidth: 500,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.autoScale(500, name: MOBILE, scaleFactor: 0.63),
            ResponsiveBreakpoint.autoScaleDown(900, name: TABLET, scaleFactor: 0.63),
            ResponsiveBreakpoint.autoScale(1440, name: DESKTOP),
          ],
         ); 
         
  }
}
