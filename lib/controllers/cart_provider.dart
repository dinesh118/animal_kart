import 'package:flutter_riverpod/legacy.dart';

class CartItem {
  final int qty;
  final int insurancePaid;

  CartItem({required this.qty, required this.insurancePaid});

  CartItem copyWith({int? qty, int? insurancePaid}) {
    return CartItem(
      qty: qty ?? this.qty,
      insurancePaid: insurancePaid ?? this.insurancePaid,
    );
  }
}

class CartController extends StateNotifier<Map<String, CartItem>> {
  CartController() : super({});

  /// Set qty (and insurance rule: pay insurance only once)
  void setItem(String id, int qty, int insurancePerBuffalo) {
    if (qty <= 0) {
      remove(id);
      return;
    }

    final insurancePaid = qty >= 2 ? insurancePerBuffalo : insurancePerBuffalo;
    state = {
      ...state,
      id: CartItem(qty: qty, insurancePaid: insurancePaid),
    };
  }

  void remove(String id) {
    if (!state.containsKey(id)) return;
    final copy = {...state};
    copy.remove(id);
    state = copy;
  }

  void increase(String id) {
    if (!state.containsKey(id)) return;
    final old = state[id]!;
    setItem(id, old.qty + 1, old.insurancePaid);
  }

  void decrease(String id) {
    if (!state.containsKey(id)) return;
    final old = state[id]!;
    setItem(id, old.qty - 1, old.insurancePaid);
  }

  int getCount(String id) => state[id]?.qty ?? 0;
}

final cartProvider =
    StateNotifierProvider<CartController, Map<String, CartItem>>(
  (ref) => CartController(),
);
