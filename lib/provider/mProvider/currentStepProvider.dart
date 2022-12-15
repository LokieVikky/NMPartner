import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/apiService.dart';
import 'apiProvider.dart';
import 'otpProvider.dart';

final currentStepNotifierProvider =
    StateNotifierProvider<CurrentStateNotifier, CurrentFormState>((ref) {
  return CurrentStateNotifier(ref);
});

class CurrentStateNotifier extends StateNotifier<CurrentFormState> {
  Ref ref;

  CurrentStateNotifier(this.ref) : super(CurrentFormState(CurrentFormStateStatus.initial, 0));

  getCurrentStep() async {
    String? partnerId = await ApiService().readPartnerId();
    int? currentStep = await ref.read(apiProvider).getCurrentStep(partnerId!);
    if(currentStep != null) {
      state = CurrentFormState(CurrentFormStateStatus.success, currentStep);
    } else {
      state = CurrentFormState(CurrentFormStateStatus.failure, 0);
    }
  }
}
enum CurrentFormStateStatus { initial, loading, success, failure }

class CurrentFormState {
  CurrentFormStateStatus? status;
  int? cState;

  CurrentFormState(this.status, this.cState);
}