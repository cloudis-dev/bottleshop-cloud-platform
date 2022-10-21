import 'package:flutter/material.dart';

import 'package:delivery/l10n/l10n.dart';

// void showCartNotifcation(BuildContext context) async {
//   final getHours = FirebaseFirestore.instance.collection('opening_hours').get();

//   final overlayState = Overlay.of(context);
//   final overlayEntry = OverlayEntry(
//     builder: (context) => Positioned(
//       left: MediaQuery.of(context).size.width * 0.2,
//       right: MediaQuery.of(context).size.width * 0.2,
//       child: GestureDetector(
//         onTap: () => showDisclaimer(context),
//         child: Card(
//           color: Theme.of(context).colorScheme.secondary,
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: const [
//                 Text(
//                   'Closing Soon!',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Divider(thickness: 1.0),
//                 Padding(
//                   padding: EdgeInsets.all(15),
//                   child: Text(
//                     'Better check your delivery options HERE',
//                     textAlign: TextAlign.left,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );

//   getHours.then((value) async {
//     final snapDoc = value.docs;
//     final todayClosingHour = snapDoc[0][weekday][1];
//     final closingHourToDouble =
//         const OpeningHoursToday().convertTimeToDouble(todayClosingHour);

//     // if (currentTimeToDouble < closingHourToDouble &&
//     //     currentTimeToDouble >= closingHourToDouble - 1.0) {
//     overlayState!.insert(overlayEntry);
//     await Future<void>.delayed(const Duration(seconds: 3));
//     overlayEntry.remove();
//   }
//       // },
//       );
// }

void showCartDisclaimer(BuildContext context) async {
  // final getDisclaimer = FirebaseFirestore.instance
  //     .collection('disclaimers')
  //     .doc('cart_closing_soon_disc_en')
  //     .get();

  // final disclaimerTitle =
  //     await getDisclaimer.then((value) => value.data()!['title']);
  // final disclaimerBody =
  //     await getDisclaimer.then((value) => value.data()!['body']);

  showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: AlertDialog(
            elevation: 10,
            // shape: const OutlineInputBorder(),
            title: Text(context.l10n.cartDisclaimerHead),
            content: Text(context.l10n.cartDisclaimerBody),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.cartDisclaimerButton),
                ),
              ),
            ],
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    barrierDismissible: false,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
  );
}
