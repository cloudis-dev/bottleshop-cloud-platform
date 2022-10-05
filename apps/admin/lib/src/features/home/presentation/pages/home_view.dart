import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:bottleshop_admin/src/core/presentation/widgets/app_navigation_drawer.dart';

class HomeView extends HookWidget {
  const HomeView({Key? key}) : super(key: key);

  // static const herotag = 'herotag';

  void _showCustomNotifcation(BuildContext context) async {
    final overlayState = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 30,
        left: 10,
        right: 10,
        child: GestureDetector(
          onTap: () {
            showDisclaimer(context);
          },
          child: Card(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            color: Colors.white.withOpacity(0.9),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sheesh... Closing soon!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(thickness: 1.0),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Better check your delivery options HERE',
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    overlayState!.insert(overlayEntry);
    await Future.delayed(Duration(seconds: 3));
    overlayEntry.remove();
  }

  void showDisclaimer(BuildContext context) => showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                elevation: 10,
                shape: OutlineInputBorder(),
                title: Text('Disclaimer'),
                content: Text(
                    'In flutter the StatefulWidget provides us a method named as initState() which is executed every single time when flutter app’s starts. The initState() method executed every time when a object is inserted into View class tree. This method will class once for each State object is created for example if we have multiple StatefulWidget classes then we can call this method multiple times and if we have single StatefulWidget class then we can call this method single time. So in this tutorial we would Flutter Call A Function Automatically When App Starts Everytime Android iOS example tutorial.'),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Scaffold();
        },
      );

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        _showCustomNotifcation(context);
      }
      ;
      focusNode.requestFocus();
    });

    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Domov'),
        ),
        drawer: const AppNavigationDrawer(),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => _showCustomNotifcation(context),
                child: Text('Disclaimer'),
              ),
              IconButton(
                focusNode: focusNode,
                onPressed: () => showDisclaimer(context),
                icon: Icon(Icons.info_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroDialogRoute extends PageRoute {
  @override
  // TODO: implement barrierColor
  Color? get barrierColor => Colors.black54;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => throw UnimplementedError();

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    throw UnimplementedError();
  }

  @override
  // TODO: implement maintainState
  bool get maintainState => throw UnimplementedError();

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => throw UnimplementedError();
}
