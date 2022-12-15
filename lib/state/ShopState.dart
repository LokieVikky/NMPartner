import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/shopInfoEntity.dart';

enum UpdateShopStatus{initial,loading, success, failure}

class ShopState {
  UpdateShopStatus status;
  AsyncValue<ShopEntity>? data;
  String? error;

  ShopState(this.status, this.data, this.error);
}