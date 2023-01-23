import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:partner/data/app_repository.dart';
import 'package:partner/entity/partnerInfoEntity.dart';

final updatePartnerControllerProvider =
    StateNotifierProvider<UpdatePartnerController, AsyncValue<bool?>>((ref) {
  return UpdatePartnerController(streamRepository: ref.watch(appRepositoryProvider));
});

class UpdatePartnerController extends StateNotifier<AsyncValue<bool?>> {
  AppRepository streamRepository;

  UpdatePartnerController({required this.streamRepository}) : super(const AsyncData(null));

  Future<void> updatePartner(PartnerInfoEntity partnerInfoEntity) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => streamRepository.updatePartner(partnerInfoEntity));
  }
}
