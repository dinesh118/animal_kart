import 'package:animal_kart_demo2/orders/providers/orders_providers.dart';
import 'package:animal_kart_demo2/orders/screens/invoice_screen.dart';
import 'package:animal_kart_demo2/orders/screens/pdf_viewer_screen.dart';
import 'package:animal_kart_demo2/orders/widgets/orders_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
    super.initState();

    // Load orders after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  Future<void> _loadOrders() async {
    try {
      await ref.read(ordersProvider.notifier).loadOrders();
    } catch (error) {
      // Show error message to user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load orders: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    final isLoading = ref.watch(ordersLoadingProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
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
                      // Handle invoice tap
                      final filePath = await InvoiceGenerator.generateInvoice(
                        order,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PdfViewerScreen(filePath: filePath),
                        ),
                      );
                      print('Invoice tapped for order: ${order.id}');
                    },
                  ),
                );
              },
            ),
    );
  }
}
