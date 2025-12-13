// monthly_revenue_widget.dart
import 'package:flutter/material.dart';

class MonthlyRevenueWidget extends StatefulWidget {
  final Map<String, dynamic> treeData;
  final int selectedYear;
  final int selectedMonth;
  final List<String> monthNames;
  final String Function(double) formatCurrency;
  final int Function(int, int, int, int) calculateMonthlyRevenueForBuffalo;
  
  const MonthlyRevenueWidget({
    super.key,
    required this.treeData,
    required this.selectedYear,
    required this.selectedMonth,
    required this.monthNames,
    required this.formatCurrency,
    required this.calculateMonthlyRevenueForBuffalo,
  });
  
  @override
  State<MonthlyRevenueWidget> createState() => _MonthlyRevenueWidgetState();
}

class _MonthlyRevenueWidgetState extends State<MonthlyRevenueWidget> {
  int _selectedUnit = 1;
  
  Map<String, dynamic> calculateDetailedMonthlyRevenue() {
    final buffaloes = widget.treeData['buffaloes'] as List<Map<String, dynamic>>;
    final monthlyRevenue = <int, Map<int, Map<String, dynamic>>>{};
    final investorMonthlyRevenue = <int, Map<int, double>>{};
    final startYear = widget.treeData['startYear'] as int;
    final years = widget.treeData['years'] as int;
    
    for (int year = startYear; year <= startYear + years; year++) {
      monthlyRevenue[year] = {};
      investorMonthlyRevenue[year] = {};
      
      for (int month = 0; month < 12; month++) {
        monthlyRevenue[year]![month] = {
          'total': 0.0,
          'buffaloes': <String, int>{}
        };
        investorMonthlyRevenue[year]![month] = 0.0;
      }
    }
    
    for (final buffalo in buffaloes) {
      for (int year = startYear; year <= startYear + years; year++) {
        for (int month = 0; month < 12; month++) {
          final generation = buffalo['generation'] as int;
          if (generation > 0) {
            final ageAtMonth = calculateAgeInMonths(buffalo, year, month);
            if (ageAtMonth < 36) continue;
          }
          
          final revenue = widget.calculateMonthlyRevenueForBuffalo(
            buffalo['acquisitionMonth'] as int,
            month,
            year,
            startYear,
          );
          
          if (revenue > 0) {
            monthlyRevenue[year]![month]!['total'] = 
                (monthlyRevenue[year]![month]!['total'] as double) + revenue;
            (monthlyRevenue[year]![month]!['buffaloes'] as Map<String, int>)[buffalo['id'] as String] = revenue;
            investorMonthlyRevenue[year]![month] = 
                investorMonthlyRevenue[year]![month]! + revenue;
          }
        }
      }
    }
    
    return {
      'monthlyRevenue': monthlyRevenue,
      'investorMonthlyRevenue': investorMonthlyRevenue,
    };
  }
  
  int calculateAgeInMonths(Map<String, dynamic> buffalo, int year, int month) {
    final birthYear = buffalo['birthYear'] as int;
    final birthMonth = buffalo['acquisitionMonth'] as int;
    final totalMonths = (year - birthYear) * 12 + (month - birthMonth);
    return totalMonths > 0 ? totalMonths : 0;
  }
  
  @override
  Widget build(BuildContext context) {
    final monthlyData = calculateDetailedMonthlyRevenue();
    final monthlyRevenue = monthlyData['monthlyRevenue'] as Map<int, Map<int, Map<String, dynamic>>>;
    final currentYearRevenue = monthlyRevenue[widget.selectedYear] ?? {};
    final units = widget.treeData['units'] as int;
    
    // Get buffaloes for selected unit
    final buffaloes = (widget.treeData['buffaloes'] as List<Map<String, dynamic>>)
        .where((buffalo) => (buffalo['unit'] as int) == _selectedUnit)
        .toList();
    
    // Calculate monthly totals
    final monthlyTotals = <String, double>{};
    for (final buffalo in buffaloes) {
      double total = 0;
      for (int month = 0; month < 12; month++) {
        final buffaloId = buffalo['id'] as String;
        final buffaloRevenue = currentYearRevenue[month]?['buffaloes'] as Map<String, dynamic>?;
        total += ((buffaloRevenue?[buffaloId] ?? 0) as int).toDouble();
      }
      monthlyTotals[buffalo['id'] as String] = total;
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
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Monthly Revenue Breakdown',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF075985),
                    ),
                  ),
                  Text(
                    '${widget.monthNames[widget.selectedMonth]} ${widget.selectedYear}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0EA5E9),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Unit Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.group, size: 20, color: Color(0xFF0EA5E9)),
                    const SizedBox(width: 8),
                    const Text(
                      'Unit:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _selectedUnit,
                      underline: const SizedBox(),
                      items: List<int>.generate(units, (index) => index + 1)
                          .map((int unit) => DropdownMenuItem<int>(
                                value: unit,
                                child: Text(
                                  'Unit $unit',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUnit = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Monthly Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) => const Color(0xFFF1F5F9),
              ),
              columns: [
                const DataColumn(
                  label: Text('Month'),
                  numeric: false,
                ),
                ...buffaloes.map((buffalo) => DataColumn(
                      label: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            buffalo['id'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (buffalo['generation'] as int) == 0 
                                ? 'Mother' 
                                : (buffalo['generation'] as int) == 1 
                                    ? 'Child' 
                                    : 'Grandchild',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      numeric: true,
                    )).toList(),
                const DataColumn(
                  label: Text('Unit\nTotal'),
                  numeric: true,
                ),
              ],
              rows: List.generate(12, (monthIndex) {
                final monthName = widget.monthNames[monthIndex];
                double unitTotal = 0;
                
                final cells = [
                  DataCell(
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        monthName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ];
                
                // Add buffalo revenue cells
                for (final buffalo in buffaloes) {
                  final buffaloId = buffalo['id'] as String;
                  final buffaloRevenue = currentYearRevenue[monthIndex]?['buffaloes'] as Map<String, dynamic>?;
                  final revenue = ((buffaloRevenue?[buffaloId] ?? 0) as int).toDouble();
                  unitTotal += revenue;
                  
                  Color bgColor;
                  if (revenue == 9000) {
                    bgColor = const Color(0xFFD1FAE5);
                  } else if (revenue == 6000) {
                    bgColor = const Color(0xFFDBEAFE);
                  } else {
                    bgColor = const Color(0xFFF1F5F9);
                  }
                  
                  cells.add(
                    DataCell(
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.formatCurrency(revenue),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: revenue > 0
                                    ? revenue == 9000
                                        ? const Color(0xFF065F46)
                                        : const Color(0xFF1E40AF)
                                    : Colors.grey,
                              ),
                            ),
                            if (revenue > 0)
                              Text(
                                revenue == 9000 ? 'High' : 'Medium',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: revenue == 9000
                                      ? const Color(0xFF059669)
                                      : const Color(0xFF3B82F6),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                
                // Add unit total cell
                cells.add(
                  DataCell(
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.formatCurrency(unitTotal),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),
                );
                
                return DataRow(cells: cells);
              }),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Summary Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.2 : 1.5,
            children: [
              // Annual Revenue Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Annual Revenue',
                      style: TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.formatCurrency(monthlyTotals.values.fold(0.0, (a, b) => a + b)),
                      style: const TextStyle(
                        color: Color(0xFF1E293B),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.selectedYear.toString(),
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Average Monthly Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Avg Monthly',
                      style: TextStyle(
                        color: Color(0xFF92400E),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.formatCurrency(monthlyTotals.values.fold(0.0, (a, b) => a + b) / 12),
                      style: const TextStyle(
                        color: Color(0xFF92400E),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'per month',
                      style: TextStyle(
                        color: Color(0xFFB45309),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Active Buffaloes Card
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
                      'Active Buffaloes',
                      style: TextStyle(
                        color: Color(0xFF065F46),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      buffaloes.length.toString(),
                      style: const TextStyle(
                        color: Color(0xFF065F46),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Unit $_selectedUnit',
                      style: const TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // High Revenue Months
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
                      'High Revenue',
                      style: TextStyle(
                        color: Color(0xFF1E40AF),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      monthlyTotals.values.where((v) => v >= 9000 * 5).length.toString(),
                      style: const TextStyle(
                        color: Color(0xFF1E40AF),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'buffaloes',
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Buffalo Details
          if (buffaloes.isNotEmpty) ...[
            const Text(
              'Buffalo Details:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: buffaloes.map((buffalo) {
                final totalRevenue = monthlyTotals[buffalo['id'] as String] ?? 0;
                final generation = buffalo['generation'] as int;
                final acquisitionMonth = buffalo['acquisitionMonth'] as int;
                final birthYear = buffalo['birthYear'] as int;
                
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: generation == 0
                        ? const Color(0xFFFEF3C7)
                        : generation == 1
                            ? const Color(0xFFD1FAE5)
                            : const Color(0xFFE0E7FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: generation == 0
                          ? const Color(0xFFF59E0B)
                          : generation == 1
                              ? const Color(0xFF10B981)
                              : const Color(0xFF8B5CF6),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            buffalo['id'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: generation == 0
                                  ? const Color(0xFF92400E)
                                  : generation == 1
                                      ? const Color(0xFF065F46)
                                      : const Color(0xFF3730A3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: generation == 0
                                  ? const Color(0xFFFDE68A)
                                  : generation == 1
                                      ? const Color(0xFFA7F3D0)
                                      : const Color(0xFFC7D2FE),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              generation == 0
                                  ? 'Mother'
                                  : generation == 1
                                      ? 'Child'
                                      : 'Grandchild',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: generation == 0
                                    ? const Color(0xFF92400E)
                                    : generation == 1
                                        ? const Color(0xFF065F46)
                                        : const Color(0xFF3730A3),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: ${widget.formatCurrency(totalRevenue)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Acquired: ${widget.monthNames[acquisitionMonth]} $birthYear',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}