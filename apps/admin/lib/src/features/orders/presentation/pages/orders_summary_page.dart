import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/app_page.dart';
import 'package:bottleshop_admin/src/core/data/services/database_service.dart';
import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/core/utils/formatting_util.dart';
import 'package:bottleshop_admin/src/features/orders/data/models/order_model.dart';
import 'package:bottleshop_admin/src/features/orders/data/services/services.dart';
import 'package:bottleshop_admin/src/features/products/data/services/services.dart';
import 'package:collection/collection.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';

final _selectedDateProvider = StateProvider.autoDispose<DateTimeRange?>((_) => null);

class _TableRecord {
  final String productName;
  final String ean;
  final int quantity;
  final String stockState;

  _TableRecord({
    required this.productName,
    required this.ean,
    required this.quantity,
    required this.stockState,
  });
}

typedef _DaysOffset = int;

final _ordersForDayProvider = FutureProvider.autoDispose
    .family<List<_TableRecord>, _DaysOffset>((ref, daysOffset) async {
  final dateTime = ref.watch(_selectedDateProvider).state;

  if (dateTime == null) {
    return Future.value([]);
  } else {
    final res = await ordersDbService.getQueryList(
      args: [
        QueryArgs(
          OrderModel.createdAtTimestampField,
          isGreaterThanOrEqualTo:
              DateTime(dateTime.start.year, dateTime.start.month, dateTime.start.day)
        ),
        QueryArgs(
          OrderModel.createdAtTimestampField,
          isLessThan: DateTime(dateTime.end.year, dateTime.end.month, dateTime.end.day)
            //  .add(Duration(days: 1)),
        )
      ],
    );
    final groups = groupBy<Tuple4<String, String, String, int>,
        Tuple3<String, String, String>>(
      res
          .map((e) => e.cartItems.map((e) => Tuple4(
                e.product.uniqueId,
                e.product.name,
                e.product.ean,
                e.count,
              )))
          .expand((element) => element),
      (e) => Tuple3(e.item1, e.item2, e.item3),
    );

    return Future.wait(
      groups.entries.map(
        (e) => productsDbService.getSingle(e.key.item1).then(
              (value) => _TableRecord(
                productName: e.key.item2,
                ean: e.key.item3,
                quantity: e.value
                    .map((e) => e.item4)
                    .reduce((value, element) => value + element),
                stockState: value?.count.toString() ?? 'odstránený',
              ),
            ),
      ),
    );
  }
});

class OrdersSummaryPage extends AppPage {
  OrdersSummaryPage()
      : super(
          'orders_summary',
          (_) => _OrdersDetailView(),
        );
}

class _OrdersDetailView extends HookWidget {


  const _OrdersDetailView();

  @override
  Widget build(BuildContext context) {
    final scrollCtrl = useScrollController();
    final selectedDate = useProvider(_selectedDateProvider).state;

    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sumarizácia objednávok'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: context.read(navigationProvider.notifier).popPage,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            ElevatedButton(
              child: Text('Vyber dátum'),
              onPressed: () async {
                final res = await showDateRangePicker(
                  firstDate: DateTime(2021),
                  initialDateRange: DateTimeRange(
                    start: DateTime.now(),
                    end: DateTime.now().add(Duration(days: 1)),
                  ),
                  context: context,
                  lastDate: DateTime.now().add(Duration(days: 1)),
                );

                if (res != null && context.mounted) {
                  context.read(_selectedDateProvider).state = res;
                }
              },
            ),
            const SizedBox(height: 16),
            if (selectedDate != null) ...[
              Text(
                'Vybraný dátum: ${FormattingUtil.getDateString(selectedDate.start)} - ${FormattingUtil.getDateString(selectedDate.end)}',
                textAlign: TextAlign.center,
                style: AppTheme.headline1TextStyle,
              ),
              const SizedBox(height: 2),
              Text(
                'Zobrazujú sa produkty pre ktoré objednávka bola VYTVORENÁ vo vybraný deň',
                textAlign: TextAlign.center,
              ),
              useProvider(_ordersForDayProvider(0)).when(
                data: (e) => Scrollbar(
                  controller: scrollCtrl,
                  isAlwaysShown: true,
                  child: SingleChildScrollView(
                    controller: scrollCtrl,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showBottomBorder: true,
                      columns: [
                        DataColumn(label: Text('Názov')),
                        DataColumn(label: Text('EAN')),
                        DataColumn(label: Text('Predané v deň')),
                        DataColumn(label: Text('Naskladnené')),
                      ],
                      rows: e
                          .map(
                            (e) => DataRow(
                              cells: [
                                DataCell(Text(e.productName)),
                                DataCell(Text(e.ean)),
                                DataCell(Text(e.quantity.toString())),
                                DataCell(Text(e.stockState)),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                loading: () => const SizedBox(
                  height: 100,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                error: (err, stack) {
                  FirebaseCrashlytics.instance.recordError(err, stack);
                  return Text('Error');
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
