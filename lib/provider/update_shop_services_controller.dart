import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:partner/data/app_repository.dart';
import 'package:partner/entity/partnerInfoEntity.dart';
import 'package:partner/entity/shopInfoEntity.dart';
import 'package:partner/models/mModel/nm_service.dart';

final updateShopServicesControllerProvider =
    StateNotifierProvider<UpdateShopServicesController, AsyncValue<bool?>>((ref) {
  return UpdateShopServicesController(streamRepository: ref.watch(appRepositoryProvider));
});

class UpdateShopServicesController extends StateNotifier<AsyncValue<bool?>> {
  AppRepository streamRepository;

  UpdateShopServicesController({required this.streamRepository}) : super(const AsyncData(null));

  Future<void> updateShop(String shopId, List<NMService> shopServices) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => streamRepository.insertService(shopId, shopServices));
  }
}
