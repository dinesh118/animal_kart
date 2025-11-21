// import 'package:animal_kart_demo2/controllers/buffalo_provider.dart';
// import 'package:animal_kart_demo2/controllers/cart_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CartScreen extends ConsumerWidget {
//   const CartScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final cart = ref.watch(cartProvider);
//     final buffaloList = ref.watch(buffaloListProvider);

//     final items = buffaloList.where((b) => cart.containsKey(b.id)).toList();

//     if (items.isEmpty) {
//       return const Scaffold(
//         body: Center(
//           child: Text(
//             "Your cart is empty",
//             style: TextStyle(fontSize: 18, color: Colors.grey),
//           ),
//         ),
//       );
//     }

//     /// Calculate Grand Total
//     int grandTotal = 0;
//     for (final buff in items) {
//       final item = cart[buff.id]!;
//       final buffaloCost = buff.price * item.qty;
//       final insuranceCost = item.insurancePaid;
//       grandTotal += (buffaloCost + insuranceCost);
//     }

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,

//       /// ------------------------------------------------------------
//       /// BOTTOM STICKY TOTAL + PLACE ORDER
//       /// ------------------------------------------------------------
//       bottomNavigationBar: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 6,
//               offset: const Offset(0, -2),
//               color: Colors.black.withOpacity(0.1),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Total: ₹$grandTotal",
//               style: const TextStyle(
//                 color: Colors.blue,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Order Placed Successfully!")),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 28,
//                   vertical: 14,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text("Place Order", style: TextStyle(fontSize: 16)),
//             ),
//           ],
//         ),
//       ),

//       /// ------------------------------------------------------------
//       /// MAIN CART LIST
//       /// ------------------------------------------------------------
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           ...items.map((buff) {
//             final item = cart[buff.id]!;
//             final qty = item.qty;

//             final buffaloCost = buff.price * qty;
//             final insuranceCost = item.insurancePaid;
//             final itemTotal = buffaloCost + insuranceCost;

//             return Container(
//               margin: const EdgeInsets.only(bottom: 18),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                     blurRadius: 6,
//                     offset: const Offset(0, 2),
//                     color: Colors.black.withOpacity(0.05),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(18),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Breed Name
//                   Text(
//                     buff.breed,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   /// Details
//                   Text(
//                     "Milk Yield: ${buff.milkYield} L/day",
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                   Text("Quantity: $qty", style: const TextStyle(fontSize: 14)),

//                   const SizedBox(height: 12),

//                   /// ------------------------------------------------------------
//                   /// PRICE BREAKDOWN - TABLE FORMAT
//                   /// ------------------------------------------------------------
//                   Container(
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Price Breakdown",
//                           style: TextStyle(
//                             color: Colors.grey.shade700,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 12),

//                         /// ---------------- TABLE HEADER ----------------
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: const [
//                             Expanded(
//                               child: Text(
//                                 "Sl. No",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "Price",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "Insurance",
//                                 textAlign: TextAlign.right,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const Divider(),

//                         /// ---------------- ROW 1 ----------------
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Expanded(child: Text("1")),
//                             Expanded(child: Text("₹${buff.price}")),
//                             Expanded(
//                               child: Text(
//                                 insuranceCost > 0
//                                     ? "₹${insuranceCost}"
//                                     : "FREE",
//                                 textAlign: TextAlign.right,
//                                 style: TextStyle(
//                                   color: insuranceCost == 0
//                                       ? Colors.green
//                                       : Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         /// ---------------- ROW 2 (qty ≥ 2) ----------------
//                         if (qty >= 2) ...[
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Expanded(child: Text("2")),
//                               Expanded(child: Text("₹${buff.price}")),
//                               const Expanded(
//                                 child: Text(
//                                   "FREE",
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],

//                         const SizedBox(height: 12),
//                         const Divider(height: 22),

//                         /// ---------------- SUBTOTAL ----------------
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               "Subtotal",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               "₹$itemTotal",
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
