import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/partnerEntity.dart';

enum UpdatePartnerStatus{initial,loading, success, failure}

class PartnerState {
  UpdatePartnerStatus status;
  AsyncValue<PartnerEntity>? partnerEntity;
  String? error;

  PartnerState(this.status,this.partnerEntity, this.error);
}