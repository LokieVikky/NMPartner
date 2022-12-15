import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/services/apiService.dart';

import '../../entity/shopInfoEntity.dart';
import '../../state/ShopState.dart';

final shopInfoNotifierProvider =
    StateNotifierProvider<ShopInfoNotifier, ShopState>((ref) {
  return ShopInfoNotifier(ref);
});

class ShopInfoNotifier extends StateNotifier<ShopState> {
  Ref ref;

  ShopInfoNotifier(this.ref)
      : super(ShopState(UpdateShopStatus.initial, AsyncLoading(), ''));

  insertShopInfo(ShopEntity shop) async {
    try {
      state = await _loadingState();
      final data = await ApiService().insertShop(shop);
      if (data != null) {
        state = _dataState(data);
      } else {
        state = _errorState('data is null');
      }
    } catch (e) {
      print(e);
      state = _errorState('data is null');
    }
  }

  setLoadingState() {
    state = _loadingState();
  }

  _loadingState() {
    return ShopState(UpdateShopStatus.loading, AsyncLoading(), state.error);
  }

  _dataState(dynamic data) {
    return ShopState(UpdateShopStatus.success, AsyncData(data), state.error);
  }

  _errorState(String err) {
    return ShopState(UpdateShopStatus.failure, state.data, err);
  }
}
