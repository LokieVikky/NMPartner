import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:partner/entity/verificationEntity.dart';
import 'package:partner/services/apiService.dart';

import '../../state/otpState.dart';

final otpNotifierProvider = StateNotifierProvider<OtpNotifier, OtpState>((ref) {
  return OtpNotifier(ref);
});

class OtpNotifier extends StateNotifier<OtpState> {
  Ref ref;

  OtpNotifier(this.ref) : super(OtpState(false, AsyncLoading(), ''));

  getOtp(String phoneNumber) async {
    state = await _loading();
    Response otpRes = await ApiService().getOtpFor(phoneNumber);

    if (otpRes.statusCode == 200) {
      print('Res 0');
      Response tokenRes = await ApiService().getApId(otpRes.body, phoneNumber);
      if (tokenRes.statusCode == 200) {
        Map<String, dynamic> decoded = JwtDecoder.decode(tokenRes.body);
        String adminSecret =
            decoded['https://hasura.io/jwt/claims']['x-hasura-user-id'];
        if (otpRes.body.isNotEmpty && adminSecret.isNotEmpty) {
          state = _dataState(VerificationEntity(
              otpRes.body,
              decoded['https://hasura.io/jwt/claims']['x-hasura-user-id'],
              tokenRes.body,
              '+91' + phoneNumber));
        } else {
          state = _errorState(0, 'something went wrong');
        }
      } else {
        print('error 2');
        state = _errorState(otpRes.statusCode, '');
      }
    } else {
      print('error 1');
      state = _errorState(otpRes.statusCode, '');
    }
    return state;
  }

  OtpState _dataState(VerificationEntity entity) {
    return OtpState(false, AsyncData(entity), '');
  }

  OtpState _loading() {
    return OtpState(true, state.verificationEntity, '');
  }

  OtpState _errorState(int statusCode, String errMsg) {
    return OtpState(false, state.verificationEntity,
        'response code $statusCode  msg $errMsg');
  }
}
