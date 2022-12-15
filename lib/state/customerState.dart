import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/pendingOrderInfo.dart';

class PendingOrderState {
  bool? isLoading;
  AsyncValue<PendingOrderInfo>? data;
  String? error;

  PendingOrderState(this.isLoading, this.data, this.error);
}