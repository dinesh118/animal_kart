// asset_market_value_widget.dart
import 'package:flutter/material.dart';

class AssetMarketValueWidget extends StatefulWidget {
  final Map<String, dynamic> treeData;
  final List<Map<String, dynamic>> buffaloes;
  final int selectedYear;
  final Map<String, dynamic> Function(int) getBuffaloValueByAge;
  final String Function(double) formatCurrency;
  final int Function(Map<String, dynamic>, int, int) calculateAgeInMonths;
  final List<String> monthNames;
  
  const AssetMarketValueWidget({
    super.key,
    required this.treeData,
    required this.buffaloes,
    required this.selectedYear,
    required this.getBuffaloValueByAge,
    required this.formatCurrency,
    required this.calculateAgeInMonths,
    required this.monthNames,
  });
  
  @override
  State<AssetMarketValueWidget> createState() => _AssetMarketValueWidgetState();
}

class _AssetMarketValueWidgetState extends State<AssetMarketValueWidget> {
  late int _currentSelectedYear;
  
  @override
  void initState() {
    super.initState();
    _currentSelectedYear = widget.selectedYear;
  }
  
  Map<String, dynamic> calculateAssetValueForYear(int year) {
    final ageGroups = {
      '0-6 months (Calves)': {'count': 0, 'value': 0, 'unitValue': 3000},
      '6-12 months': {'count': 0, 'value': 0, 'unitValue': 6000},
      '12-18 months': {'count': 0, 'value': 0, 'unitValue': 12000},
      '18-24 months': {'count': 0, 'value': 0, 'unitValue': 25000},
      '24-30 months': {'count': 0, 'value': 0, 'unitValue': 35000},
      '30-36 months': {'count': 0, 'value': 0, 'unitValue': 50000},
      '36-40 months': {'count': 0, 'value': 0, 'unitValue': 50000},
      '40-48 months': {'count': 0, 'value': 0, 'unitValue': 100000},
      '48-60 months': {'count': 0, 'value': 0, 'unitValue': 150000},
      '60+ months (Mother Buffalo)': {'count': 0, 'value': 0, 'unitValue': 175000}
    };
    
    double totalValue = 0;
    int totalCount = 0;
    
    for (final buffalo in widget.buffaloes) {
      final buffaloBirthYear = buffalo['birthYear'] as int;
      if (year >= buffaloBirthYear) {
        final ageInMonths = widget.calculateAgeInMonths(buffalo, year, 11);
        final valueData = widget.getBuffaloValueByAge(ageInMonths);
        final value = (valueData['value'] ?? 0) as int;
        
        String ageGroup;
        if (ageInMonths >= 60) {
          ageGroup = '60+ months (Mother Buffalo)';
        } else if (ageInMonths >= 48) {
          ageGroup = '48-60 months';
        } else if (ageInMonths >= 40) {
          ageGroup = '40-48 months';
        } else if (ageInMonths >= 36) {
          ageGroup = '36-40 months';
        } else if (ageInMonths >= 30) {
          ageGroup = '30-36 months';
        } else if (ageInMonths >= 24) {
          ageGroup = '24-30 months';
        } else if (ageInMonths >= 18) {
          ageGroup = '18-24 months';
        } else if (ageInMonths >= 12) {
          ageGroup = '12-18 months';
        } else if (ageInMonths >= 6) {
          ageGroup = '6-12 months';
        } else {
          ageGroup = '0-6 months (Calves)';
        }
        
        ageGroups[ageGroup]!['count'] = (ageGroups[ageGroup]!['count'] as int) + 1;
        ageGroups[ageGroup]!['value'] = (ageGroups[ageGroup]!['value'] as int) + value;
        totalValue += value.toDouble();
        totalCount++;
      }
    }
    
    return {
      'ageGroups': ageGroups,
      'totalValue': totalValue,
      'totalCount': totalCount,
    };
  }
  
  List<Map<String, dynamic>> calculateYearlyAssetValues() {
    final yearlyValues = <Map<String, dynamic>>[];
    final startYear = widget.treeData['startYear'] as int;
    final endYear = startYear + 9;
    
    for (int year = startYear; year <= endYear; year++) {
      yearlyValues.add(calculateAssetValueForYear(year));
    }
    
    return yearlyValues;
  }
  
  @override
  Widget build(BuildContext context) {
    final currentAssetData = calculateAssetValueForYear(_currentSelectedYear);
    final yearlyAssetValues = calculateYearlyAssetValues();
    final startYear = widget.treeData['startYear'] as int;
    
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
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Asset Market Value Analysis',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF075985),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Year Selector and Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                // Year Selector
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Year for Valuation:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<int>(
                        isExpanded: true,
                        value: _currentSelectedYear,
                        items: List<int>.generate(10, (index) => startYear + index)
                            .map((int year) => DropdownMenuItem<int>(
                                  value: year,
                                  child: Text(
                                    '$year (Year ${year - startYear + 1})',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _currentSelectedYear = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // Total Value Display
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Total Asset Value',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.formatCurrency((currentAssetData['totalValue'] as double)),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${currentAssetData['totalCount'] as int} buffaloes',
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
          ),
          
          const SizedBox(height: 24),
          
          // Age Group Breakdown
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
                  'Age-Based Valuation Breakdown',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                ...(currentAssetData['ageGroups'] as Map<String, Map<String, dynamic>>).entries
                    .where((entry) => (entry.value['count'] as int) > 0)
                    .map((entry) {
                  final ageGroup = entry.key;
                  final data = entry.value;
                  final count = data['count'] as int;
                  final value = data['value'] as int;
                  final totalValue = currentAssetData['totalValue'] as double;
                  final percentage = totalValue > 0
                      ? (value / totalValue * 100)
                      : 0;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            ageGroup,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.formatCurrency((data['unitValue'] as int).toDouble()),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7C3AED),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.formatCurrency(value.toDouble()),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF059669),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: percentage / 100,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      percentage > 0 
                                          ? const Color(0xFF4F46E5)
                                          : Colors.grey,
                                    ),
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    '${percentage.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: percentage > 0
                                          ? const Color(0xFF475569)
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Yearly Trend
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
                  'Yearly Asset Value Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) => const Color(0xFFF1F5F9),
                    ),
                    columns: const [
                      DataColumn(label: Text('Year')),
                      DataColumn(label: Text('Total\nBuffaloes'), numeric: true),
                      DataColumn(label: Text('Total Value'), numeric: true),
                      DataColumn(label: Text('Avg per\nBuffalo'), numeric: true),
                      DataColumn(label: Text('Growth'), numeric: true),
                    ],
                    rows: yearlyAssetValues.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final year = startYear + index;
                      final totalValue = data['totalValue'] as double;
                      final prevTotalValue = index > 0 
                          ? (yearlyAssetValues[index - 1]['totalValue'] as double)
                          : 0.0;
                      final growth = index > 0 && prevTotalValue > 0
                          ? ((totalValue - prevTotalValue) / prevTotalValue * 100)
                          : 0.0;
                      
                      return DataRow(
                        cells: [
                          DataCell(Text('Year ${index + 1} ($year)')),
                          DataCell(
                            Center(
                              child: Text(
                                (data['totalCount'] as int).toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF7C3AED),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                widget.formatCurrency(totalValue),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF059669),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                widget.formatCurrency(totalValue / (data['totalCount'] as int)),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0EA5E9),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: growth > 0
                                      ? const Color(0xFFD1FAE5)
                                      : const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  growth > 0 ? '+${growth.toStringAsFixed(1)}%' : '${growth.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: growth > 0
                                        ? const Color(0xFF065F46)
                                        : const Color(0xFFDC2626),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Price Schedule
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Age-Based Price Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildPriceCard('0-6 months', '₹3,000', const Color(0xFFDBEAFE), const Color(0xFF1E40AF), 'New born'),
                    _buildPriceCard('6-12 months', '₹6,000', const Color(0xFFD1FAE5), const Color(0xFF065F46), 'Growing'),
                    _buildPriceCard('12-18 months', '₹12,000', const Color(0xFFFEF3C7), const Color(0xFF92400E), 'Growing'),
                    _buildPriceCard('18-24 months', '₹25,000', const Color(0xFFFCE7F3), const Color(0xFF831843), 'Growing'),
                    _buildPriceCard('24-30 months', '₹35,000', const Color(0xFFE0E7FF), const Color(0xFF3730A3), 'Growing'),
                    _buildPriceCard('30-36 months', '₹50,000', const Color(0xFFFEF3C7), const Color(0xFF92400E), 'Transition'),
                    _buildPriceCard('36-40 months', '₹50,000', const Color(0xFFDBEAFE), const Color(0xFF1E40AF), 'Transition'),
                    _buildPriceCard('40-48 months', '₹1,00,000', const Color(0xFFD1FAE5), const Color(0xFF065F46), '4+ years'),
                    _buildPriceCard('48-60 months', '₹1,50,000', const Color(0xFFFEF3C7), const Color(0xFF92400E), '5th year'),
                    _buildPriceCard('60+ months', '₹1,75,000', const Color(0xFFFEE2E2), const Color(0xFF991B1B), 'Mother buffalo'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPriceCard(String age, String price, Color bgColor, Color textColor, String desc) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            age,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}