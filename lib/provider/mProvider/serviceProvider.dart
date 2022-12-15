import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/models/mModel/modelService.dart';
import 'package:partner/services/apiService.dart';

// availableService
final serviceNotifierProvider =
    StateNotifierProvider<ServiceNotifier, Map<String, ModelService>>((ref) {
  return ServiceNotifier(ref);
});

class ServiceNotifier extends StateNotifier<Map<String, ModelService>> {
  Ref ref;

  ServiceNotifier(this.ref) : super({});

  getAllService() async {
    state = await ApiService().getServiceList();
  }
}

// selectedService
final selectedServiceNotifierProvider =
    StateNotifierProvider<SelectedServiceNotifier, Map<String, ModelService>>(
        (ref) {
  return SelectedServiceNotifier(ref);
});

class SelectedServiceNotifier extends StateNotifier<Map<String, ModelService>> {
  Ref ref;

  SelectedServiceNotifier(this.ref) : super({});

  addService(ModelService item) {
    var tempState = state;
    state = {};
    tempState[item.id] = item;
    state = tempState;
    print(state);
  }

  removeService(ModelService item) {
    var tempState = state;
    state = {};
    tempState.remove(item.id);
    state = tempState;
    print(state);
  }

}
