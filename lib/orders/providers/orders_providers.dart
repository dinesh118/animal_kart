import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../network/api_services.dart';
import '../models/order_model.dart';

final ordersProvider =
    StateNotifierProvider<OrdersController, List<OrderUnit>>(
  (ref) => OrdersController(ref),
);

final ordersLoadingProvider = StateProvider<bool>((ref) => false);

class OrdersController extends StateNotifier<List<OrderUnit>> {
  final Ref ref;

  OrdersController(this.ref) : super([]);

  Future<void> loadOrders({required String userId}) async {
    try {
      ref.read(ordersLoadingProvider.notifier).state = true;

      if (userId.isEmpty) {
        state = [];
        return;
      }

      final orders = await ApiServices.fetchOrders(userId);
      state = orders;
    } catch (error) {
      state = [];
      rethrow;
    } finally {
      ref.read(ordersLoadingProvider.notifier).state = false;
    }
  }
}
