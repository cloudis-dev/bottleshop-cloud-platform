import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:delivery/src/features/opening_hours/presentation/widgets/opening_hours_today.dart';

void showCartNotifcation(BuildContext context) async {
  final getHours = FirebaseFirestore.instance.collection('opening_hours').get();

  final overlayState = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      left: MediaQuery.of(context).size.width * 0.2,
      right: MediaQuery.of(context).size.width * 0.2,
      child: GestureDetector(
        onTap: () => showDisclaimer(context),
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Closing Soon!',
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

  getHours.then((value) async {
    final snapDoc = value.docs;
    final todayClosingHour = snapDoc[0][weekday][1];
    final closingHourToDouble =
        const OpeningHoursToday().convertTimeToDouble(todayClosingHour);

    // if (currentTimeToDouble < closingHourToDouble &&
    //     currentTimeToDouble >= closingHourToDouble - 1.0) {
    overlayState!.insert(overlayEntry);
    await Future<void>.delayed(const Duration(seconds: 3));
    overlayEntry.remove();
  }
      // },
      );
}

void showDisclaimer(BuildContext context) async {
  final getDisclaimer = FirebaseFirestore.instance
      .collection('disclaimers')
      .doc('cart_closing_soon_disc_en')
      .get();

  final disclaimerTitle =
      await getDisclaimer.then((value) => value.data()!['title']);
  final disclaimerBody =
      await getDisclaimer.then((value) => value.data()!['body']);

  showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: AlertDialog(
            elevation: 10,
            shape: const OutlineInputBorder(),
            title: Text(disclaimerTitle),
            content: Text(disclaimerBody),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
  );
}
