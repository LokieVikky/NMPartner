import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/features/auth/data/auth_repository.dart';

final sendOTPControllerProvider =
    StateNotifierProvider.autoDispose<SendOTPController, AsyncValue<String>>(
        (ref) {
  return SendOTPController(
    authRepository: ref.watch(authRepositoryProvider),
  );
});

class SendOTPController extends StateNotifier<AsyncValue<String>> {
  AuthRepository authRepository;

  SendOTPController({required this.authRepository})
      : super(const AsyncData(''));

  Future<void> sendOTP({required String mobileNumber}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => authRepository.sendOTP(mobileNumber: mobileNumber));
  }

  void clearVerificationId() {
    state = const AsyncData('');
  }
}
