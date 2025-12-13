// annual_revenue_widget.dart
import 'package:flutter/material.dart';

class AnnualRevenueWidget extends StatelessWidget {
  final List<Map<String, dynamic>> yearlyData;
  final Map<int, double> yearlyCPFCost;
  final String Function(double) formatCurrency;
  final String Function(int) formatNumber;
  
  const AnnualRevenueWidget({
    super.key,
    required this.yearlyData,
    required this.yearlyCPFCost,
    required this.formatCurrency,
    required this.formatNumber,
  });
  
  @override
  Widget build(BuildContext context) {
    // Calculate cumulative data
    final cumulativeData = <Map<String, dynamic>>[];
    double cumulativeRevenueWithCPF = 0;
    
    for (int i = 0; i < yearlyData.length; i++) {
      final yearData = yearlyData[i];
      final cpfCost = yearlyCPFCost[yearData['year']] ?? 0;
      final revenueWithoutCPF = yearData['revenue'] as double;
      final revenueWithCPF = revenueWithoutCPF - cpfCost;
      
      cumulativeRevenueWithCPF += revenueWithCPF;
      
      cumulativeData.add({
        ...yearData,
        'cpfCost': cpfCost,
        'revenueWithoutCPF': revenueWithoutCPF,
        'revenueWithCPF': revenueWithCPF,
        'cumulativeRevenueWithCPF': cumulativeRevenueWithCPF,
      });
    }
    
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
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text(
                    'Annual Herd Revenue Analysis',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF065F46),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'with CPF',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) => const Color(0xFFF1F5F9),
              ),
              columns: const [
                DataColumn(
                  label: Text('Year'),
                  numeric: false,
                ),
                DataColumn(
                  label: Text('Total\nBuffaloes'),
                  numeric: true,
                ),
                DataColumn(
                  label: Text('Annual Revenue\n(With CPF)'),
                  numeric: true,
                ),
                DataColumn(
                  label: Text('Growth'),
                  numeric: true,
                ),
              ],
              rows: cumulativeData.map((data) {
                final year = data['year'] as int;
                final totalBuffaloes = data['totalBuffaloes'] as int;
                final annualRevenue = data['revenueWithCPF'] as double;
                final index = cumulativeData.indexOf(data);
                final growthRate = index > 0
                    ? ((annualRevenue - cumulativeData[index - 1]['revenueWithCPF']) /
                        cumulativeData[index - 1]['revenueWithCPF'] * 100)
                    : 0;
                
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                year.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Year ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formatNumber(totalBuffaloes),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                          const Text(
                            'total buffaloes',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formatCurrency(annualRevenue),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                            ),
                          ),
                          Text(
                            'CPF: -${formatCurrency(data['cpfCost'] as double)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFD97706),
                            ),
                          ),
                          if (growthRate > 0)
                            Text(
                              '↑ ${growthRate.toStringAsFixed(1)}% growth',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF059669),
                              ),
                            ),
                        ],
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: growthRate > 0 
                              ? const Color(0xFFD1FAE5)
                              : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          growthRate > 0 ? '+${growthRate.toStringAsFixed(1)}%' : '${growthRate.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: growthRate > 0 
                                ? const Color(0xFF065F46)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Summary Cards
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              // Total Revenue Card
              Container(
                width: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Revenue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency(cumulativeData.map((d) => d['revenueWithCPF'] as double)
                          .reduce((a, b) => a + b)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${yearlyData.length} years',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Average Annual Card
              Container(
                width: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF059669), Color(0xFF10B981)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Avg Annual',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency(cumulativeData.map((d) => d['revenueWithCPF'] as double)
                          .reduce((a, b) => a + b) / cumulativeData.length),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'per year',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Final Herd Size Card
              Container(
                width: 200,
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
                      'Final Herd',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatNumber(cumulativeData.last['totalBuffaloes'] as int),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'buffaloes',
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
        ],
      ),
    );
  }
}