import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:partner/entity/orderListEntity.dart';
import 'package:partner/services/apiService.dart';
import 'package:partner/state/orderListState.dart';

import '../../state/orderStatusState.dart';

// placed orders
final placedOrderListNotifierProvider =
    StateNotifierProvider<OrderListNotifier, OrderListState>((ref) {
  return OrderListNotifier(ref);
});

class OrderListNotifier extends StateNotifier<OrderListState> {
  final Ref ref;

  OrderListNotifier(this.ref)
      : super(OrderListState(false, AsyncLoading(), "", true));

  getOrderList() async {
    state = _loadingState();
    List<OrderListEntity> result = await ApiService().getOrderList();

    if (result != null) {
      state = _dataState(result);
    } else {
      state = _errorState('result null');
    }
  }

  OrderListState _errorState(String errtxt) {
    return OrderListState(false, state.entity, errtxt, false);
  }

  OrderListState _loadingState() {
    return OrderListState(true, state.entity, state.error, false);
  }

  OrderListState _dataState(List<OrderListEntity> data) {
    return OrderListState(false, AsyncData(data), state.error, false);
  }
}

final getActionRequiredOrdersNotifierProvider =
    StateNotifierProvider<GetActionRequiredOrdersNotifier, OrderListState>(
        (ref) {
  return GetActionRequiredOrdersNotifier(ref);
});

// getActionRequired Orders
class GetActionRequiredOrdersNotifier extends StateNotifier<OrderListState> {
  Ref ref;

  GetActionRequiredOrdersNotifier(this.ref)
      : super(OrderListState(false, AsyncLoading(), '', true));

  getActionRequired() async {
    state = _loadingState();
    var data = await ApiService().getActionRequiredOrders();
    if (data != null) {
      state = _dataState(data);
    } else {
      state = _errorState('data is null');
    }
  }

  OrderListState _errorState(String errtxt) {
    return OrderListState(false, state.entity, errtxt, false);
  }

  OrderListState _loadingState() {
    return OrderListState(true, state.entity, state.error, false);
  }

  OrderListState _dataState(List<OrderListEntity> data) {
    return OrderListState(false, AsyncData(data), state.error, false);
  }
}

// change Order status
final changeOrderStatusNotifierProvider =
    StateNotifierProvider<ChangeOrderStatusNotifier, OrderStatusState>((ref) {
  return ChangeOrderStatusNotifier(ref);
});

class ChangeOrderStatusNotifier extends StateNotifier<OrderStatusState> {
  Ref ref;

  ChangeOrderStatusNotifier(this.ref)
      : super(OrderStatusState(false, AsyncLoading(), ''));

  Future<bool> changeStatus(String orderId, String status) async {
    var data = await ApiService().changeOrderStatus(orderId, status);
    await ref.read(placedOrderListNotifierProvider.notifier).getOrderList();
    await ref.read(getActionRequiredOrdersNotifierProvider.notifier).getActionRequired();
    if (data != null) {
      if (data['order_id'] == orderId && data['status'] == status) {
        return true;
      }
      return false;
    } else {
      return false;
    }
  }
}

// orderStatusList
final statusListNotifierProvider = StateNotifierProvider<StatusNotifier, List<String>> ((ref) {
  return StatusNotifier(ref);
});

class StatusNotifier extends StateNotifier<List<String>> {
  Ref ref;

  StatusNotifier(this.ref) : super([]);

  getOrdersList() async {
    state = await ApiService().getStatusList();
  }
}