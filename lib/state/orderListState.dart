import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/orderListEntity.dart';

class OrderListState {
  bool? isLoading;
  AsyncValue<List<WorkOrder>>? entity;
  String? error;
  bool? initState;

  OrderListState(this.isLoading, this.entity, this.error, this.initState);
}