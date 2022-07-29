import 'package:bottleshop_admin/features/section_flash_sales/data/models/flash_sale_model.dart';
import 'package:flutter/material.dart';

class FlashSaleViewModel extends ChangeNotifier {
  FlashSaleModel? _editedFlashSale;

  FlashSaleModel get currentFlashSale => _editedFlashSale ?? initialFlashSale;
  final FlashSaleModel initialFlashSale;

  FlashSaleViewModel(this.initialFlashSale);

  bool isFlashSaleUntilChanged() =>
      _editedFlashSale != null &&
      initialFlashSale.flashSaleUntil != _editedFlashSale!.flashSaleUntil;

  void changeDateInFlashSaleUntil(DateTime date) {
    final currentTime = currentFlashSale.flashSaleUntilTime;
    final newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      currentTime.hour,
      currentTime.minute,
      date.second,
    );
    changeFlashSaleUntil(newDateTime);
  }

  void changeTimeInFlashSaleUntil(TimeOfDay time) {
    final currentDateTime = currentFlashSale.flashSaleUntilDate;
    final newDateTime = DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      time.hour,
      time.minute,
      currentDateTime.second,
    );
    changeFlashSaleUntil(newDateTime);
  }

  void changeFlashSaleUntil(DateTime flashSaleUntil) {
    _modify(
      currentFlashSale.copyWith(flashSaleUntil: flashSaleUntil),
    );
  }

  void _modify(FlashSaleModel newModel) {
    _editedFlashSale = newModel;
    notifyListeners();
  }
}
