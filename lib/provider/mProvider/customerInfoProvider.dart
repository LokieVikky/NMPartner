import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/entity/pendingOrderInfo.dart';
import 'package:partner/services/apiService.dart';

import '../../state/customerState.dart';

final pendingOrderInfoNotifierProvider =
    StateNotifierProvider<PendingOrderInfoNotifier, PendingOrderState>((ref) {
  return PendingOrderInfoNotifier(ref);
});

class PendingOrderInfoNotifier extends StateNotifier<PendingOrderState> {
  Ref ref;

  PendingOrderInfoNotifier(this.ref)
      : super(PendingOrderState(false, AsyncLoading(), ''));

  getPendingOrders(String custId, String orderId) async {
    state = _loadingState();
    String? shopId = await ApiService().readShopId();
    final data = await ApiService().getPendingOrderInfo(shopId!, orderId);
    if (data != null) {
      state = _dataState(data);
    } else {
      state = _errorState('data is null');
    }
  }

  PendingOrderState _loadingState() {
    return PendingOrderState(true, state.data, state.error);
  }

  PendingOrderState _dataState(PendingOrderInfo entity) {
    return PendingOrderState(false, AsyncData(entity), state.error);
  }

  PendingOrderState _errorState(String err) {
    return PendingOrderState(false, state.data, err);
  }
}
