import 'package:animal_kart_demo2/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';

class BuffaloOrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTapInvoice;

  const BuffaloOrderCard({
    super.key,
    required this.order,
    this.onTapInvoice,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isPending = order.orderStatus.toLowerCase() == "pending";
    final bool isConfirmed = order.orderStatus.toLowerCase() == "confirmed";

    final Color statusColor = isPending
        ? Colors.orange
        : isConfirmed
            ? Colors.green
            : Colors.grey;

    // Localized status using context.tr
    final String localizedStatus = isPending
        ? context.tr("pending")
        : isConfirmed
            ? context.tr("confirmed")
            : context.tr("completed");

    return Container(
      // Removed bottom margin to control spacing via ListView padding only
      padding: const EdgeInsets.all(12), // slightly smaller padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row → Order ID + Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${order.id}",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.038,
                      ),
                    ),
                    if (order.orderPlacedOn != null) const SizedBox(height: 2),
                    if (order.orderPlacedOn != null)
                      Text(
                        "${context.tr("orderPlaced")}: ${order.orderPlacedOn}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              // ------------ STATUS BADGE --------------
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  localizedStatus.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 8),

          // -------------- IMAGE + DETAILS ---------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buffalo Image
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    order.buffaloImages.isNotEmpty
                        ? order.buffaloImages.first
                        : "https://via.placeholder.com/150",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // -------- Details -------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breed
                    Text(
                      order.breed,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.036,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // AGE localized
                    Text(
                      "${context.tr("age")}: ${order.age} ${context.tr("years")}",
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 6),

                    // ------------ CPF + PAID + INVOICE -------------
                   // ------------ CPF + PAID + INVOICE -------------
Row(
  mainAxisAlignment: MainAxisAlignment.start, // use start to avoid too much space
  children: [
    // CPF Quantity
    Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 1.2),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "${order.cpfQuantity}x ${context.tr("unit")}",
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.028,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
    const SizedBox(width: 8),

    // Paid Amount
    if (order.paidAmount != null)
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black, width: 1.2),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "₹${order.paidAmount} ${context.tr("paid")}",
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.028,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    const SizedBox(width: 8),

    // Invoice Button
    if (order.invoiceUrl != null)
      Flexible(
        child: InkWell(
          onTap: onTapInvoice,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                context.tr("invoice"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
  ],
)

                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
