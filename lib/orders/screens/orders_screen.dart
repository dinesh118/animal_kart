import 'package:animal_kart_demo2/orders/screens/invoice_screen.dart';
import 'package:animal_kart_demo2/orders/screens/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import '../providers/orders_providers.dart';
import '../widgets/orders_card_widget.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ordersProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
    backgroundColor: const Color(0xffF5F5F5),
    // appBar: AppBar(
    //   automaticallyImplyLeading: false,
    //   backgroundColor: Colors.white,
    //   elevation: 0,
    //   title: Row(
    //     children: [
    //       GestureDetector(
    //         onTap: () {
    //           Navigator.pushNamedAndRemoveUntil(
    //             context,
    //             '/home',
    //             (route) => false,
    //           );
    //         },
    //         child: const Icon(Icons.arrow_back_ios,
    //             color: Colors.black, size: 18),
    //       ),
    //       const SizedBox(width: 6),
    //       const Text(
    //         "Order History",
    //         style: TextStyle(
    //           color: Colors.black,
    //           fontWeight: FontWeight.w600,
    //           fontSize: 20,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
   


      body: orders.isEmpty
          ? const Center(
              child: Text(
                "No Orders Available",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: BuffaloOrderCard(
                    order: order,
                    onTapInvoice: () async {
  final path = await InvoiceGenerator.generateInvoice();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PdfViewerScreen(filePath: path),
    ),
  );
},

                    
//                     onTapInvoice: () async {
//   final path = await InvoiceGenerator.generateInvoice();
//   await OpenFile.open(path);
// },

                    // onTapInvoice: () async {
                    //   // Show loader
                    //   showDialog(
                    //     context: context,
                    //     barrierDismissible: false,
                    //     builder: (_) =>
                    //         const Center(child: CircularProgressIndicator()),
                    //   );

                    //   try {
                    //     // Generate invoice PDF
                    //  //   final path = await InvoiceGenerator.generateInvoice();

                    //     // Close loader
                    //     Navigator.of(context).pop();

                    //     // Navigate to InvoiceScreen
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => InvoiceScreen(order: order,),
                    //       ),
                    //     );
                    //   } catch (e) {
                    //     Navigator.of(context).pop(); // Close loader
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text("Error: $e")),
                    //     );
                    //   }
                    // },
                  ),
                );
              },
            ),

    );
  }
}
