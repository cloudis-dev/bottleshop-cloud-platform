import 'package:delivery/src/core/data/models/common_data_state.dart';
import 'package:delivery/src/core/data/services/common_data_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonDataRepository extends StateNotifier<AsyncValue<void>> {
  final CommonDataService dataService;
  late CommonDataState _dataState;

  CommonDataState get data => _dataState;

  CommonDataRepository({required this.dataService})
      : super(const AsyncValue.data(null)) {
    _dataState = CommonDataState.empty();
  }

  Future<void> init() async {
    try {
      state = const AsyncValue.loading();
      _dataState = await dataService.fetchAll();
    } catch (e) {
      state = const AsyncValue.error('Could not fetch critical data');
    } finally {
      _dataState = CommonDataState.empty();
      state = const AsyncValue.data(null);
    }
  }

  Future<void> refresh() async {
    try {
      state = const AsyncValue.loading();
      _dataState = CommonDataState.empty();
      _dataState = await dataService.fetchAll();
    } catch (e) {
      state = const AsyncValue.error('Could not fetch critical data');
    } finally {
      _dataState = CommonDataState.empty();
      state = const AsyncValue.data(null);
    }
  }
}
