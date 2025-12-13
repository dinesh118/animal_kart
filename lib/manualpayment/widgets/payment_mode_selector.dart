// lib/manualpayment/widgets/payment_mode_selector.dart
import 'package:flutter/material.dart';

class PaymentModeSelector extends StatelessWidget {
  final bool isBankSelected;
  final bool isChequeSelected;
  final VoidCallback onBankSelected;
  final VoidCallback onChequeSelected;

  const PaymentModeSelector({
    super.key,
    required this.isBankSelected,
    required this.isChequeSelected,
    required this.onBankSelected,
    required this.onChequeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PaymentModeButton(
            title: "Bank Transfer",
            isSelected: isBankSelected,
            color: Colors.green,
            onTap: onBankSelected,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _PaymentModeButton(
            title: "Cheque",
            isSelected: isChequeSelected,
            color: Colors.orange,
            onTap: onChequeSelected,
          ),
        ),
      ],
    );
  }
}

class _PaymentModeButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _PaymentModeButton({
    required this.title,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}