import 'package:animal_kart_demo2/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:animal_kart_demo2/l10n/app_localizations.dart';

class ReferBottomSheet extends StatelessWidget {
  final String referralCode;

  const ReferBottomSheet({super.key, required this.referralCode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6),

          // Title
          Text(
            context.tr('refer_earn_title'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),

          // Description
          Text(
            context.tr("refer_description"),
            style: const TextStyle(fontSize: 13, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),

          // Referral Code Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.18),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  referralCode,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.6),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () {
                    final message = "${context.tr('refer_earn_title')} - $referralCode";
                    Clipboard.setData(ClipboardData(text: message));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.tr("copy_message")),
                        duration: const Duration(milliseconds: 900),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // How it works
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              context.tr("how_it_works"),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 10),

          _stepTile(context, "1️⃣  ${context.tr("step1")}"),
          _stepTile(context, "2️⃣  ${context.tr("step2")}"),
          _stepTile(context, "3️⃣  ${context.tr("step3")}"),

          const SizedBox(height: 18),

          // SHARE BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _shareReferral(),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryDarkColor, // Replace kPrimaryDarkColor if needed
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Text(
                context.tr('share'),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _stepTile(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _shareReferral() {
    Share.share("Use my referral code $referralCode and get 1000 coins on signup! 🐃🔥");
  }
}
