import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/app_navigation_drawer.dart';
import 'package:bottleshop_admin/src/core/utils/snackbar_utils.dart';
import 'package:bottleshop_admin/src/features/open_hours/data/models/open_hours_model.dart';
import 'package:bottleshop_admin/src/features/open_hours/data/providers/providers.dart';
import 'package:bottleshop_admin/src/features/open_hours/data/services/services.dart';
import 'package:bottleshop_admin/src/features/open_hours/presentation/widgets/change-date.dart';
import 'package:bottleshop_admin/src/features/open_hours/presentation/widgets/change-hour.dart';
import 'package:bottleshop_admin/src/features/promo_codes/data/models/promo_code_model.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/dialogs/promo_code_delete_dialog.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/pages/promo_code_editing_page.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/promo_codes/presentation/widgets/promo_code_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

final _messengerKey = Provider.autoDispose<GlobalKey<ScaffoldMessengerState>>(
    (_) => GlobalKey<ScaffoldMessengerState>());

final isButtonVisible = useState(false);

class OpenHoursView extends HookWidget {
  const OpenHoursView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: useProvider(_messengerKey),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Rozvrh'),
        ),
        drawer: const AppNavigationDrawer(),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final val = useProvider(openHoursStreamProvider);
    return val.when(
        data: (data) {
          var otherDays = data.where((element) =>
              element.type != 'Workdays' &&
              element.type != 'Friday' &&
              element.type != 'Sunday' &&
              element.type != 'Saturday');
          return Column(
            children: [
              ChangeHour(
                val: data.firstWhere((element) => element.type == 'Saturday'),
              ),
              ChangeHour(
                val: data.firstWhere((element) => element.type == 'Sunday'),
              ),
              ChangeHour(
                val: data.firstWhere((element) => element.type == 'Friday'),
              ),
              ChangeHour(
                val: data.firstWhere((element) => element.type == 'Workdays'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Expanded(child: Divider()),
              ),
              SizedBox(
                height: 200,
                child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: otherDays.length == 0
                        ? TextButton(
                            onPressed: () async {
                              final emptyDoc = FirebaseFirestore.instance
                                  .collection(Constants.openHoursCollection)
                                  .doc();
                              final batch = FirebaseFirestore.instance.batch();
                              final dtNow = DateTime.now();
                              await openHoursDb.create({
                                'dateFrom': dtNow,
                                'dateTo': DateTime(dtNow.year, dtNow.month,
                                    dtNow.day, dtNow.hour + 1),
                                'isClosed': false,
                                'type': emptyDoc.id
                              }, id: emptyDoc.id, batch: batch);
                              await batch.commit();
                            },
                            child: Text('Nova doba'),
                          )
                        : ListView.builder(
                            itemCount: otherDays.length,
                            itemBuilder: (_, index) {
                              return ChangeDate(
                                  val: otherDays.elementAt(index));
                            })),
              ),
            ],
          );
        },
        error: (error, stack) => Text(error.toString()),
        loading: () => CircularProgressIndicator());
  }
}
