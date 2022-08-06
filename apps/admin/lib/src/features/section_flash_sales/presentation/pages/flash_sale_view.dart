import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/product_card.dart';
import 'package:bottleshop_admin/src/core/utils/formatting_util.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/data/models/flash_sale_model.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/presentation/widgets/product_card_flash_sale_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:streamed_items_state_management/streamed_items_state_management.dart';

class FlashSaleView extends HookWidget {
  const FlashSaleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return useProvider(isFlashSaleLoadedProvider)
        ? _DataContent()
        : const Center(
            child: SizedBox(
              height: 100,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
  }
}

class _DataContent extends HookWidget {
  const _DataContent();

  @override
  Widget build(BuildContext context) {
    final flashSale = useProvider(
      flashSaleViewModelProvider.select((value) => value.initialFlashSale),
    );
    final flashSaleProductsState = useProvider(
      flashSaleProductsProvider(flashSale.uniqueId)
          .select((value) => value.itemsState),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomScrollView(
        slivers: [
          _FlashSaleDetails(flashSale),
          SliverPagedList(
            itemsState: flashSaleProductsState,
            itemBuilder: (context, dynamic item, _) => ProductCard(
              product: item,
              productCardMenuButtonBuilder: (_) =>
                  ProductCardFlashSaleMenuButton(item),
            ),
            requestData: () {},
          ),
        ],
      ),
    );
  }
}

Future<void> _onTimePicked(
    BuildContext context, FlashSaleModel flashSale) async {
  final time = await showTimePicker(
    context: context,
    initialTime: context
        .read(flashSaleViewModelProvider)
        .currentFlashSale
        .flashSaleUntilTime, //TimeOfDay.now(),
  );

  if (time != null) {
    context.read(flashSaleViewModelProvider).changeTimeInFlashSaleUntil(time);
  }
}

Future<void> _onDatePicked(
    BuildContext context, FlashSaleModel flashSale) async {
  final now = DateTime.now();
  final currentSetDate = context
      .read(flashSaleViewModelProvider)
      .currentFlashSale
      .flashSaleUntilDate;

  final initialDate = currentSetDate.compareTo(now) > 0 ? currentSetDate : now;

  final dateTime = await showDatePicker(
    firstDate: now,
    initialDate: initialDate,
    context: context,
    lastDate: now.add(Duration(days: 60)),
  );

  if (dateTime != null) {
    context
        .read(flashSaleViewModelProvider)
        .changeDateInFlashSaleUntil(dateTime);
  }
}

class _FlashSaleDetails extends HookWidget {
  final FlashSaleModel flashSale;

  const _FlashSaleDetails(this.flashSale);

  @override
  Widget build(BuildContext context) {
    final currentFlashSale = useProvider(
      flashSaleViewModelProvider.select((value) => value.currentFlashSale),
    );

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flash Sale (bleskový výpredaj)',
            style: AppTheme.headline1TextStyle,
          ),
          Row(
            children: [
              Text(
                'Pre pridanie produktu pokračujte cez produkty',
                style: AppTheme.subtitle1TextStyle,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.widgets,
                  color: AppTheme.mediumGreySolid,
                ),
              ),
            ],
          ),
          const Divider(),
          Text(
            'Koniec Flash Sale',
            style: AppTheme.headline3TextStyle,
          ),
          ElevatedButton(
            child: Text('Vyber dátum'),
            onPressed: () async => _onDatePicked(context, currentFlashSale),
          ),
          ElevatedButton(
            child: Text('Vyber čas'),
            onPressed: () async => _onTimePicked(context, currentFlashSale),
          ),
          _SelectedDateWidget(currentFlashSale),
          _SelectedTimeWidget(currentFlashSale),
          _CountdownWidget(currentFlashSale),
          _UpdateFlashSaleUntilButton(currentFlashSale),
          const Divider(),
        ],
      ),
    );
  }
}

class _SelectedDateWidget extends HookWidget {
  final FlashSaleModel flashSale;

  const _SelectedDateWidget(this.flashSale);

  @override
  Widget build(BuildContext context) {
    final date = useProvider(
      flashSaleViewModelProvider
          .select((value) => value.currentFlashSale.flashSaleUntilDate),
    );

    return Text(
      'Vybraný dátum: ${FormattingUtil.getDateString(date)}',
    );
  }
}

class _SelectedTimeWidget extends HookWidget {
  final FlashSaleModel flashSale;

  const _SelectedTimeWidget(this.flashSale);

  @override
  Widget build(BuildContext context) {
    final time = useProvider(
      flashSaleViewModelProvider
          .select((value) => value.currentFlashSale.flashSaleUntilTime),
    );

    return Text(
      'Vybraný čas: ${FormattingUtil.getTimeStringFromTimeOfDay(context, time)}',
    );
  }
}

class _CountdownWidget extends HookWidget {
  final FlashSaleModel flashSale;

  const _CountdownWidget(this.flashSale);

  @override
  Widget build(BuildContext context) {
    final diff = useProvider(timeDifferenceProvider(flashSale));

    if (diff.isNegative) {
      return RichText(
        text: TextSpan(
          text: 'Čas je už v minulosti: ',
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: 'Flash Sale je neaktívny',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      );
    } else {
      return Text(
        'Zostávajúci čas: ${FormattingUtil.getTimeDifferenceString(diff)}',
      );
    }
  }
}

class _UpdateFlashSaleUntilButton extends HookWidget {
  final FlashSaleModel flashSale;

  const _UpdateFlashSaleUntilButton(this.flashSale);

  @override
  Widget build(BuildContext context) {
    final isUntilChanged = useProvider(
      flashSaleViewModelProvider
          .select((value) => value.isFlashSaleUntilChanged()),
    );

    if (isUntilChanged) {
      return ElevatedButton(
        child: Text('Aktualizovať Flash sale čas'),
        onPressed: () {
          final model =
              context.read(flashSaleViewModelProvider).currentFlashSale;

          context.read(flashSalesRepository).updateFlashSale(model);
        },
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
