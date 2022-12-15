import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/entity/ProfileEntity.dart';
import 'package:partner/services/apiService.dart';

import '../../state/ProfileState.dart';

// Get Profile Info
final profileNotifierProvider = StateNotifierProvider<
    ProfileNotifier,
    ProfileState>((ref) {
  return ProfileNotifier(ref);
});

class ProfileNotifier extends StateNotifier<ProfileState> {
  Ref ref;

  ProfileNotifier(this.ref) : super(_initState());

  getProfileInfo() async {
    state = _lodingState();
    final receivedData = await ApiService().getProfileInfo();
    if (receivedData != null) {
      state = _dataState(receivedData);
    } else {
      state = _errorState('null');
    }
  }

  updateProfile(ProfileEntity entity) async {
    state = _lodingState();
    var result = await ApiService().updateProfile(entity);
    if(result != null) {
      await getProfileInfo();
      return state;
    }
    return null;
  }

  static ProfileState _initState() {
    return ProfileState(false, AsyncLoading(), '', true);
  }

  ProfileState _lodingState() {
    return ProfileState(true, state.profileEntity, state.errorTxt, false);
  }

  ProfileState _errorState(String err) {
    return ProfileState(false, state.profileEntity, err, false);
  }

  ProfileState _dataState(ProfileEntity entity) {
    return ProfileState(false, AsyncData(entity), state.errorTxt, false);
  }
}