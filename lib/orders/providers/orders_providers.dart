import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../network/api_services.dart';
import '../models/order_model.dart';

final ordersProvider =
    StateNotifierProvider<OrdersController, List<OrderUnit>>(
  (ref) => OrdersController(ref),
);

final ordersLoadingProvider = StateProvider<bool>((ref) => false);
final hasPendingOrder = Provider<bool>((ref) {
  final orders = ref.watch(ordersProvider);

  return orders.any((order) {
    final status = order.paymentStatus.toUpperCase();
    return status == "PENDING_PAYMENT" ||
           status == "PENDING_ADMIN_VERIFICATION";
  });
});

class OrdersController extends StateNotifier<List<OrderUnit>> {
  final Ref ref;
  
  OrdersController(this.ref) : super([]);

  Future<void> loadOrders() async {
    try {
     
      ref.read(ordersLoadingProvider.notifier).state = true;
      
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userMobile');

      if (userId == null) {
        state = [];
        ref.read(ordersLoadingProvider.notifier).state = false;
        return;
      }

      final orders = await ApiServices.fetchOrders(userId);
      state = orders;
    } catch (error) {
      
      state = [];
     
    } finally {
      
      ref.read(ordersLoadingProvider.notifier).state = false;
    }
  }
}