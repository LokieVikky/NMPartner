import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/ProfileEntity.dart';

class ProfileState {
  bool? loading;
  AsyncValue<ProfileEntity>? profileEntity;
  String? errorTxt;
  bool? initState;

  ProfileState(this.loading, this.profileEntity, this.errorTxt, this.initState);
}
