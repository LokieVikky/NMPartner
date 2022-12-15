import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/features/auth/data/auth_repository.dart';

final verifyOTPControllerProvider =
    StateNotifierProvider.autoDispose<VerifyOTPController, AsyncValue<void>>((ref) {
  return VerifyOTPController(
    authRepository: ref.watch(authRepositoryProvider),
  );
});

class VerifyOTPController extends StateNotifier<AsyncValue<void>> {
  AuthRepository authRepository;

  VerifyOTPController({required this.authRepository}) : super(const AsyncData(null));

  Future<void> sendOTP({required String verificationId, required String otp}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => authRepository.loginWithOtp(verificationId: verificationId, otp: otp));
  }
}
