import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:partner/data/app_repository.dart';
import 'package:partner/entity/partnerInfoEntity.dart';
import 'package:partner/entity/shopInfoEntity.dart';

final updateShopControllerProvider =
    StateNotifierProvider<UpdateShopController, AsyncValue<String?>>((ref) {
  return UpdateShopController(streamRepository: ref.watch(appRepositoryProvider));
});

class UpdateShopController extends StateNotifier<AsyncValue<String?>> {
  AppRepository streamRepository;

  UpdateShopController({required this.streamRepository}) : super(const AsyncData(null));

  Future<void> updateShop(ShopEntity shopEntity) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => streamRepository.updateShop(shopEntity));
  }
}
