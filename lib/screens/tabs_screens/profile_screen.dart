// import 'package:animal_kart_demo2/controllers/user_provider.dart';
// import 'package:animal_kart_demo2/routes/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class UserProfileScreen extends ConsumerWidget {
//   const UserProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(userProfileProvider);

//     if (user == null) {
//       return const Center(
//         child: Text("No profile found. Please complete your profile."),
//       );
//     }

//     return Scaffold(

//       backgroundColor: Colors.grey.shade100,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             /// PROFILE HEADER
//             Container(
//               padding: const EdgeInsets.all(20),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Column(
//                 children: [
//                   const CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Colors.blue,
//                     child: Icon(Icons.person, size: 45, color: Colors.white),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     user.name,
//                     style: const TextStyle(
//                         fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     user.phone,
//                     style: const TextStyle(color: Colors.grey, fontSize: 15),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 20),

//             /// DETAILS CARD
//             _infoCard(
//               title: "Personal Information",
//               items: {
//                 "Name": user.name,
//                 "Gender": user.gender,
//                 "Date of Birth": user.dob,
//                 "Email": user.email.isEmpty ? "Not Provided" : user.email,
//               },
//             ),

//             const SizedBox(height: 15),

//             _infoCard(
//               title: "Aadhar Details",
//               items: {
//                 "Aadhar Number": user.aadharNumber,
//               },
//             ),

//             const SizedBox(height: 15),

//             _infoCard(
//               title: "Address Details",
//               items: {
//                 "Address 1": user.address1,
//                 "Address 2": user.address2.isEmpty
//                     ? "Not Provided"
//                     : user.address2,
//                 "City": user.city,
//                 "State": user.state,
//                 "Pincode": user.pincode,
//               },
//             ),

//             const SizedBox(height: 30),

//             /// LOGOUT BUTTON
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onPressed: () {
//                   ref.read(userProfileProvider.notifier).logout();

//                    Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     AppRoutes.login,
//                     (route) => false,
//                   );
//                 },
//                 child: const Text(
//                   "Logout",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoCard({required String title, required Map<String, String> items}) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style:
//                   const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const Divider(),
//           ...items.entries.map(
//             (e) => Padding(
//               padding: const EdgeInsets.only(bottom: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(e.key,
//                       style: const TextStyle(
//                           color: Colors.grey, fontSize: 14)),
//                   Text(e.value,
//                       style: const TextStyle(
//                           fontSize: 15, fontWeight: FontWeight.w600)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
