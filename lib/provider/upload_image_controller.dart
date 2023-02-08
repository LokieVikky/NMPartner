import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:partner/data/app_repository.dart';

final imageUploadControllerProvider =
    StateNotifierProvider.family<ImageUploadController, AsyncValue<String?>, XFile>((ref, arg) {
  return ImageUploadController(streamRepository: ref.watch(appRepositoryProvider), image: arg);
});

class ImageUploadController extends StateNotifier<AsyncValue<String?>> {
  AppRepository streamRepository;
  XFile image;

  ImageUploadController({required this.streamRepository, required this.image})
      : super(const AsyncData(null)){
    uploadImage();
  }

  Future<void> uploadImage() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => uploadImageToServer(image));
  }

  Future<String> uploadImageToServer(XFile image) async {
    try {
      String? accessToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      http.MultipartRequest request = http.MultipartRequest('POST',Uri.parse("http://3.131.69.3:8080/upload"))..headers.addAll({
        'Authorization': 'Bearer $accessToken',
      })..files.add(await http.MultipartFile.fromPath('file', image.path));
      var response = await request.send();
      if(response.statusCode==200){
        final respStr = await response.stream.bytesToString();
        final respJson = jsonDecode(respStr);
        return respJson['fileName'];
      }
      print(await response.stream.bytesToString());
      throw Exception(await response.stream.bytesToString());
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
