import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmer extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const CommonShimmer({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF0D47A1).withValues(alpha:0.6), // dark blue base
      highlightColor: const Color(0xFF0D47A1).withValues(alpha:0.3), // lighter RHS
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFF0D47A1).withValues(alpha: 0.08),
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

Widget ordersShimmerList() {
  return ListView.builder(
    padding: const EdgeInsets.only(
      left: 16,
      right: 16,
      bottom: 16,
    ),
    itemCount: 6, // number of shimmer cards
    itemBuilder: (context, index) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: CommonShimmer(height: 200,),
      );
    },
  );
}
