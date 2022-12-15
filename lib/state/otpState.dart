
import 'package:partner/entity/verificationEntity.dart';
import 'package:riverpod/riverpod.dart';

class OtpState {
  bool isLoading;
  AsyncValue<VerificationEntity> verificationEntity;
  String error;

  OtpState(this.isLoading, this.verificationEntity, this.error);
}