// import 'package:flutter_riverpod/legacy.dart';

// class CartItem {
//   final int qty;
//   final int insurancePaid;

//   CartItem({
//     required this.qty,
//     required this.insurancePaid,
//   });

//   CartItem copyWith({int? qty, int? insurancePaid}) {
//     return CartItem(
//       qty: qty ?? this.qty,
//       insurancePaid: insurancePaid ?? this.insurancePaid,
//     );
//   }
// }

// final cartProvider =
//     StateNotifierProvider<CartController, Map<String, CartItem>>(
//   (ref) => CartController(),
// );

// class CartController extends StateNotifier<Map<String, CartItem>> {
//   CartController() : super({});

//   /// Add 1 buffalo + insurance
//   void addSingle(String id, int insurance) {
//     state = {
//       ...state,
//       id: CartItem(qty: 1, insurancePaid: insurance),
//     };
//   }

//   /// Add 2 buffalo + only 1 insurance (1 free)
//   void addDoubleOffer(String id, int insurance) {
//     state = {
//       ...state,
//       id: CartItem(qty: 2, insurancePaid: insurance),
//     };
//   }

//   void increase(String id) {
//     if (!state.containsKey(id)) return;

//     state = {
//       ...state,
//       id: state[id]!.copyWith(qty: state[id]!.qty + 1),
//     };
//   }

//   void decrease(String id) {
//     if (!state.containsKey(id)) return;

//     if (state[id]!.qty == 1) {
//       state.remove(id);
//       state = {...state};
//       return;
//     }

//     state = {
//       ...state,
//       id: state[id]!.copyWith(qty: state[id]!.qty - 1),
//     };
//   }

//   int getCount(String id) => state[id]?.qty ?? 0;
// }
