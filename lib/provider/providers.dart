import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/data/app_repository.dart';

final registrationStatusProvider = FutureProvider<int?>((ref) async {
  return await ref
      .read(appRepositoryProvider)
      .getCurrentStep(FirebaseAuth.instance.currentUser?.uid);
});
