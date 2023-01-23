import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/data/app_repository.dart';
import 'package:partner/entity/partnerEntity.dart';
import 'package:partner/entity/partnerInfoEntity.dart';
import 'package:partner/provider/providers.dart';

import '../../state/partnerState.dart';

final partnerNotifierProvider = StateNotifierProvider<PartnerNotifier, PartnerState>((ref) {
  return PartnerNotifier(ref);
});

class PartnerNotifier extends StateNotifier<PartnerState> {
  Ref ref;

  PartnerNotifier(this.ref)
      : super(PartnerState(UpdatePartnerStatus.initial, AsyncData(PartnerEntity('', '', '')), ''));

  updatePartnerInfo(PartnerInfoEntity partnerInfoModel) async {
    state = await _isLoading();
    var data = await ref.read(appRepositoryProvider).updatePartner(partnerInfoModel);
    if (data != null) {
      ref.refresh(registrationStatusProvider);
      state = _dataState();
    } else {
      state = await _errorState();
    }
  }

  setLoadingState() {
    state = _isLoading();
  }

  _isLoading() {
    return PartnerState(UpdatePartnerStatus.loading, state.partnerEntity, state.error);
  }

  _dataState() {
    return PartnerState(
        UpdatePartnerStatus.success, AsyncData(PartnerEntity('', '', '')), state.error);
  }

  _errorState() {
    return PartnerState(UpdatePartnerStatus.failure, state.partnerEntity, 'error occured');
  }
}
