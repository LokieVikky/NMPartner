import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderStatusState {
  bool? isLoading;
  AsyncValue<OrderStatusEntity>? data;
  String? error;

  OrderStatusState(this.isLoading, this.data, this.error);
}

class OrderStatusEntity {
  String? orderId;
  String? status;

  OrderStatusEntity(this.orderId, this.status);
}