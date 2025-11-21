// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/buffalo.dart';
// import '../controllers/cart_provider.dart';

// class BuffaloCard extends ConsumerWidget {
//   final Buffalo buffalo;

//   const BuffaloCard({super.key, required this.buffalo});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final qty = ref.watch(cartProvider)[buffalo.id]?.qty ?? 0;

//     final disabled = !buffalo.inStock;

//     return Opacity(
//       opacity: disabled ? 0.4 : 1,
//       child: Container(
//         margin: const EdgeInsets.all(12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// TOP: Breed + Healthy badge
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(buffalo.breed,
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold)),

//                 disabled
//                     ? Container(
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: Colors.red.shade100,
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: const Text("Out of Stock",
//                             style: TextStyle(color: Colors.red)),
//                       )
//                     : Container(
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade100,
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: const Text(
//                           "Healthy",
//                           style: TextStyle(color: Colors.green),
//                         ),
//                       ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             /// Milk Yield
//             Row(
//               children: [
//                 const Text("Milk Yield: ",
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                 Text(
//                   "${buffalo.milkYield} L/day",
//                   style: const TextStyle(
//                       fontSize: 16,
//                       color: Colors.green,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),

//             const SizedBox(height: 10),

//             /// Insurance info icon
//             InkWell(
//               onTap: () => _showInsuranceInfo(context),
//               child: Row(
//                 children: const [
//                   Icon(Icons.info_outline, size: 20, color: Colors.blue),
//                   SizedBox(width: 6),
//                   Text(
//                     "Insurance Details",
//                     style: TextStyle(color: Colors.blue),
//                   )
//                 ],
//               ),
//             ),

//             const SizedBox(height: 14),
//             Divider(),
//             const SizedBox(height: 10),

//             /// Price + Qty buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("₹${buffalo.price}",
//                     style: const TextStyle(
//                         color: Colors.blue,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold)),

//                 disabled
//                     ? const SizedBox()
//                     : qty == 0
//                         ? ElevatedButton(
//                             onPressed: () =>
//                                 showImprovedInsuranceDialog(context, ref, buffalo),
//                             child: const Text("Add"),
//                           )
//                         : Row(
//                             children: [
//                               _qtyButton(
//                                 icon: Icons.remove,
//                                 onTap: () => ref
//                                     .read(cartProvider.notifier)
//                                     .decrease(buffalo.id),
//                               ),
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 12),
//                                 child: Text("$qty",
//                                     style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold)),
//                               ),
//                               _qtyButton(
//                                 icon: Icons.add,
//                                 onTap: () => ref
//                                     .read(cartProvider.notifier)
//                                     .increase(buffalo.id),
//                               ),
//                             ],
//                           )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: 36,
//         height: 36,
//         decoration:
//             BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
//         child: Icon(icon, size: 20, color: Colors.blue),
//       ),
//     );
//   }

//   void _showInsuranceInfo(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text("Insurance Breakdown",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 12),
//             Text("• Life Insurance – ₹6000"),
//             Text("• Heat Insurance – ₹4000"),
//             Text("• AI Insurance – ₹3000"),
//             SizedBox(height: 16),
//             Text("Total: ₹13000",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }

//  void showImprovedInsuranceDialog(
//   BuildContext context,
//   WidgetRef ref,
//   Buffalo buffalo,
// ) {
//   showDialog(
//     context: context,
//     builder: (_) => Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(22),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(22),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // TITLE
//             const Text(
//               "Insurance Offer",
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF2C2C2C),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // TABLE BORDER BOX
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 children: [
//                   // TABLE HEADER
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: const BorderRadius.vertical(
//                         top: Radius.circular(16),
//                       ),
//                     ),
//                     child: Row(
//                       children: const [
//                         Expanded(
//                           flex: 1,
//                           child: Text(
//                             "Sl. No",
//                             style: TextStyle(
//                                 fontSize: 13, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Text(
//                             "Price",
//                             style: TextStyle(
//                                 fontSize: 13, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Text(
//                             "Insurance",
//                             style: TextStyle(
//                                 fontSize: 13, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const Divider(height: 1),

//                   // ROW 1
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 12),
//                     child: Row(
//                       children: [
//                         const Expanded(
//                           flex: 1,
//                           child: Text("1",
//                               style: TextStyle(fontSize: 13)),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Text(
//                             "₹${buffalo.price}",
//                             style: const TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Text(
//                             "₹${buffalo.insurance}",
//                             style: const TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const Divider(height: 1),

//                   // ROW 2
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 12),
//                     child: Row(
//                       children: [
//                         const Expanded(
//                           flex: 1,
//                           child: Text("2",
//                               style: TextStyle(fontSize: 13)),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Text(
//                             "₹${buffalo.price}",
//                             style: const TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         const Expanded(
//                           flex: 2,
//                           child: Text(
//                             "FREE",
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.green,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 18),

//             // NOTE BOX
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               padding: const EdgeInsets.all(14),
//               child: const Text(
//                 "Note: If you purchase 2 Murrah buffaloes, you will receive "
//                 "insurance for the second buffalo completely FREE.",
//                 style: TextStyle(fontSize: 10),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // BUTTONS
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   child: const Text(
//                     "Disagree",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.red,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   onPressed: () {
//                     ref.read(cartProvider.notifier).addSingle(
//                           buffalo.id,
//                           buffalo.insurance,
//                         );
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 12, horizontal: 28),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                   ),
//                   child: const Text(
//                     "Agree",
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   onPressed: () {
//                     ref.read(cartProvider.notifier).addDoubleOffer(
//                           buffalo.id,
//                           buffalo.insurance,
//                         );
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// }
