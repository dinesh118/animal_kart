// revenue_break_even_widget.dart
import 'package:flutter/material.dart';

class RevenueBreakEvenWidget extends StatelessWidget {
  final Map<String, dynamic> treeData;
  final List<Map<String, dynamic>> yearlyData;
  final Map<int, double> yearlyCPFCost;
  final String Function(double) formatCurrency;
  final int units;
  
  const RevenueBreakEvenWidget({
    super.key,
    required this.treeData,
    required this.yearlyData,
    required this.yearlyCPFCost,
    required this.formatCurrency,
    required this.units,
  });
  
  Map<String, dynamic> calculateBreakEvenAnalysis() {
    final initialInvestment = units * 2 * 175000 + units * 13000;
    final breakEvenData = <Map<String, dynamic>>[];
    double cumulativeRevenueWithCPF = 0;
    int? breakEvenYear;
    int? breakEvenMonth;
    DateTime? exactBreakEvenDate;
    
    // Calculate cumulative data and find break-even point
    for (int i = 0; i < yearlyData.length; i++) {
      final yearData = yearlyData[i];
      final cpfCost = yearlyCPFCost[yearData['year']] ?? 0;
      final revenueWithoutCPF = yearData['revenue'] as double;
      final revenueWithCPF = revenueWithoutCPF - cpfCost;
      
      cumulativeRevenueWithCPF += revenueWithCPF;
      
      // Check for break-even (cumulative revenue >= initial investment)
      if (cumulativeRevenueWithCPF >= initialInvestment && breakEvenYear == null) {
        breakEvenYear = yearData['year'];
        // Simple approximation for month - in reality would need monthly calculations
        breakEvenMonth = 11; // December
        exactBreakEvenDate = DateTime(yearData['year'], 12, 31);
      }
      
      final recoveryPercentage = (cumulativeRevenueWithCPF / initialInvestment * 100);
      
      String status = "In Progress";
      if (recoveryPercentage >= 100) {
        status = "✓ Break-Even Achieved";
      } else if (recoveryPercentage >= 75) {
        status = "75% Recovered";
      } else if (recoveryPercentage >= 50) {
        status = "50% Recovered";
      } else if (recoveryPercentage >= 25) {
        status = "25% Recovered";
      }
      
      breakEvenData.add({
        'year': yearData['year'],
        'annualRevenue': revenueWithCPF,
        'cpfCost': cpfCost,
        'cumulativeRevenue': cumulativeRevenueWithCPF,
        'recoveryPercentage': recoveryPercentage,
        'status': status,
        'isBreakEven': breakEvenYear == yearData['year'],
      });
    }
    
    return {
      'breakEvenData': breakEvenData,
      'breakEvenYear': breakEvenYear,
      'breakEvenMonth': breakEvenMonth,
      'exactBreakEvenDate': exactBreakEvenDate,
      'initialInvestment': initialInvestment,
      'finalCumulativeRevenue': cumulativeRevenueWithCPF,
    };
  }
  
  @override
  Widget build(BuildContext context) {
    final breakEvenAnalysis = calculateBreakEvenAnalysis();
    final breakEvenData = breakEvenAnalysis['breakEvenData'] as List<Map<String, dynamic>>;
    final initialInvestment = breakEvenAnalysis['initialInvestment'] as double;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text(
                    'Revenue Break-Even Analysis',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'with CPF',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Investment Summary Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.2 : 1.5,
            children: [
              // Mother Buffalo Cost
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDBEAFE), Color(0xFFBFDBFE)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mother Buffaloes',
                      style: TextStyle(
                        color: Color(0xFF1E40AF),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency(units * 2 * 175000),
                      style: const TextStyle(
                        color: Color(0xFF1E40AF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$units units × 2 mothers × ₹1.75L',
                      style: const TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // CPF Cost
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD1FAE5), Color(0xFFA7F3D0)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CPF Coverage',
                      style: TextStyle(
                        color: Color(0xFF065F46),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency(units * 13000),
                      style: const TextStyle(
                        color: Color(0xFF065F46),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$units units × ₹13,000',
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Total Investment
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Investment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency(initialInvestment),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${units * 2} mothers + ${units * 2} calves',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Break-Even Status
              if (breakEvenAnalysis['breakEvenYear'] != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Break-Even Reached',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Year ${breakEvenAnalysis['breakEvenYear']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: ${formatCurrency(breakEvenAnalysis['finalCumulativeRevenue'] as double)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Break-Even Timeline
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Break-Even Timeline',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                ...breakEvenData.map((data) {
                  final year = data['year'] as int;
                  final annualRevenue = data['annualRevenue'] as double;
                  final cumulativeRevenue = data['cumulativeRevenue'] as double;
                  final recoveryPercentage = data['recoveryPercentage'] as double;
                  final status = data['status'] as String;
                  final isBreakEven = data['isBreakEven'] as bool;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isBreakEven
                          ? const Color(0xFFD1FAE5)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isBreakEven
                            ? const Color(0xFF10B981)
                            : const Color(0xFFE2E8F0),
                        width: isBreakEven ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: isBreakEven
                                        ? const LinearGradient(
                                            colors: [Color(0xFF10B981), Color(0xFF059669)],
                                          )
                                        : const LinearGradient(
                                            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                                          ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (year - treeData['startYear'] + 1).toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Year $year',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    Text(
                                      '${year - treeData['startYear'] + 1} years from start',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: recoveryPercentage >= 100
                                    ? const Color(0xFFD1FAE5)
                                    : recoveryPercentage >= 75
                                        ? const Color(0xFFFEF3C7)
                                        : recoveryPercentage >= 50
                                            ? const Color(0xFFDBEAFE)
                                            : recoveryPercentage >= 25
                                                ? const Color(0xFFE0E7FF)
                                                : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: recoveryPercentage >= 100
                                      ? const Color(0xFF065F46)
                                      : recoveryPercentage >= 75
                                          ? const Color(0xFF92400E)
                                          : recoveryPercentage >= 50
                                              ? const Color(0xFF1E40AF)
                                              : recoveryPercentage >= 25
                                                  ? const Color(0xFF3730A3)
                                                  : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Progress Bar
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recovery Progress',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isBreakEven
                                        ? const Color(0xFF065F46)
                                        : const Color(0xFF475569),
                                  ),
                                ),
                                Text(
                                  '${recoveryPercentage.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isBreakEven
                                        ? const Color(0xFF059669)
                                        : const Color(0xFF4F46E5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: recoveryPercentage / 100 > 1 ? 1 : recoveryPercentage / 100,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                recoveryPercentage >= 100
                                    ? const Color(0xFF10B981)
                                    : recoveryPercentage >= 75
                                        ? const Color(0xFFF59E0B)
                                        : recoveryPercentage >= 50
                                            ? const Color(0xFF3B82F6)
                                            : recoveryPercentage >= 25
                                                ? const Color(0xFF8B5CF6)
                                                : const Color(0xFF94A3B8),
                              ),
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Revenue Details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Annual Revenue',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatCurrency(annualRevenue),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Cumulative',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatCurrency(cumulativeRevenue),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4F46E5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        if (isBreakEven) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF10B981)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF059669),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Break-even achieved! Total revenue now covers initial investment.',
                                    style: TextStyle(
                                      color: const Color(0xFF065F46),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Summary Statistics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Period',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${treeData['years']} years',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Revenue',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatCurrency(breakEvenAnalysis['finalCumulativeRevenue'] as double),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Return on Investment',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${((breakEvenAnalysis['finalCumulativeRevenue'] as double) / initialInvestment * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}