import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/services/apiService.dart';

final apiProvider = Provider<ApiService>((ref) => ApiService());
