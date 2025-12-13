// revenue_analysis_module.dart - Main Module
import 'package:animal_kart_demo2/revenueanalysis/widgets/annual_revenue_widget.dart';
import 'package:animal_kart_demo2/revenueanalysis/widgets/asset_market_value_widget.dart';
import 'package:animal_kart_demo2/revenueanalysis/widgets/monthly_revenue_widget.dart';
import 'package:animal_kart_demo2/revenueanalysis/widgets/revenue_break_even_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RevenueAnalysisModule extends StatefulWidget {
  const RevenueAnalysisModule({super.key});

  @override
  State<RevenueAnalysisModule> createState() => _RevenueAnalysisModuleState();
}

class _RevenueAnalysisModuleState extends State<RevenueAnalysisModule> {
  int _selectedTab = 0;
  int _units = 1;
  int _selectedYear = 2026;
  int _selectedMonth = 11; // December (0-indexed)
  
  // Tab titles
  final List<String> _tabTitles = [
    'Annual Revenue',
    'Monthly Revenue',
    'Asset Market Value',
    'Revenue Break Even'
  ];
  
  // Month names
  final List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  
  // Revenue configuration
  final Map<String, dynamic> revenueConfig = {
    'landingPeriod': 2,
    'highRevenuePhase': {'months': 5, 'revenue': 9000},
    'mediumRevenuePhase': {'months': 3, 'revenue': 6000},
    'restPeriod': {'months': 4, 'revenue': 0}
  };
  
  // Age-based buffalo value
 Map<String, dynamic> getBuffaloValueByAge(int ageInMonths) {
  if (ageInMonths >= 60) return {'value': 175000, 'desc': '5+ years (Mother buffalo - ₹1,75,000)'};
  else if (ageInMonths >= 48) return {'value': 150000, 'desc': '4+ years (5th year - ₹1,50,000)'};
  else if (ageInMonths >= 40) return {'value': 100000, 'desc': 'After 40 months (₹1,00,000)'};
  else if (ageInMonths >= 36) return {'value': 50000, 'desc': '36-40 months (₹50,000)'};
  else if (ageInMonths >= 30) return {'value': 50000, 'desc': '30-36 months (₹50,000)'};
  else if (ageInMonths >= 24) return {'value': 35000, 'desc': '24-30 months (₹35,000)'};
  else if (ageInMonths >= 18) return {'value': 25000, 'desc': '18-24 months (₹25,000)'};
  else if (ageInMonths >= 12) return {'value': 12000, 'desc': '12-18 months (₹12,000)'};
  else if (ageInMonths >= 6) return {'value': 6000, 'desc': '6-12 months (₹6,000)'};
  else return {'value': 3000, 'desc': '0-6 months (Calves - ₹3,000)'};
}
  
  // Calculate monthly revenue for a buffalo
  int calculateMonthlyRevenueForBuffalo(int acquisitionMonth, int currentMonth, int currentYear, int startYear) {
    final monthsSinceAcquisition = (currentYear - startYear) * 12 + (currentMonth - acquisitionMonth);
    
    if (monthsSinceAcquisition < revenueConfig['landingPeriod']) {
      return 0;
    }
    
    final productionMonth = monthsSinceAcquisition - revenueConfig['landingPeriod'];
    final cycleMonth = productionMonth % 12;
    
    if (cycleMonth < revenueConfig['highRevenuePhase']['months']) {
      return revenueConfig['highRevenuePhase']['revenue'];
    } else if (cycleMonth < revenueConfig['highRevenuePhase']['months'] + revenueConfig['mediumRevenuePhase']['months']) {
      return revenueConfig['mediumRevenuePhase']['revenue'];
    } else {
      return revenueConfig['restPeriod']['revenue'];
    }
  }
  
  // Calculate annual revenue for herd
  Map<String, dynamic> calculateAnnualRevenueForHerd(List<Map<String, dynamic>> herd, int currentYear) {
    double annualRevenue = 0;
    final matureBuffaloes = herd.where((buffalo) {
      final ageInCurrentYear = currentYear - buffalo['birthYear'];
      return ageInCurrentYear >= 3;
    }).toList();
    
    for (final buffalo in matureBuffaloes) {
      final acquisitionMonth = buffalo['acquisitionMonth'];
      
      for (int month = 0; month < 12; month++) {
        annualRevenue += calculateMonthlyRevenueForBuffalo(
          acquisitionMonth,
          month,
          currentYear,
          _selectedYear
        );
      }
    }
    
    return {
      'annualRevenue': annualRevenue,
      'matureBuffaloes': matureBuffaloes.length,
      'totalBuffaloes': herd.where((buffalo) => buffalo['birthYear'] <= currentYear).length
    };
  }
  
  // Calculate total revenue data
  Map<String, dynamic> calculateRevenueData(List<Map<String, dynamic>> herd, int totalYears) {
    final yearlyData = <Map<String, dynamic>>[];
    double totalRevenue = 0;
    double totalMatureBuffaloYears = 0;
    
    for (int yearOffset = 0; yearOffset < totalYears; yearOffset++) {
      final currentYear = _selectedYear + yearOffset;
      
      final annualRevenueData = calculateAnnualRevenueForHerd(herd, currentYear);
      final annualRevenue = annualRevenueData['annualRevenue'];
      final matureBuffaloes = annualRevenueData['matureBuffaloes'];
      final totalBuffaloes = annualRevenueData['totalBuffaloes'];
      
      totalRevenue += annualRevenue;
      totalMatureBuffaloYears += matureBuffaloes;
      
      final monthlyRevenuePerBuffalo = matureBuffaloes > 0 ? annualRevenue / (matureBuffaloes * 12) : 0;
      
      yearlyData.add({
        'year': currentYear,
        'activeUnits': (totalBuffaloes / 2).ceil(),
        'monthlyRevenue': monthlyRevenuePerBuffalo,
        'revenue': annualRevenue,
        'totalBuffaloes': totalBuffaloes,
        'producingBuffaloes': matureBuffaloes,
        'nonProducingBuffaloes': totalBuffaloes - matureBuffaloes,
        'startMonth': monthNames[_selectedMonth],
        'startYear': _selectedYear,
        'matureBuffaloes': matureBuffaloes
      });
    }
    
    return {
      'yearlyData': yearlyData,
      'totalRevenue': totalRevenue,
      'totalUnits': totalMatureBuffaloYears / totalYears,
      'averageAnnualRevenue': totalRevenue / totalYears,
      'revenueConfig': revenueConfig,
      'totalMatureBuffaloYears': totalMatureBuffaloYears
    };
  }
  
  // Run simulation
  Map<String, dynamic> runSimulation() {
    final totalYears = 10;
    final herd = <Map<String, dynamic>>[];
    final offspringCounts = <String, int>{};
    
    // Create initial buffaloes
    for (int u = 0; u < _units; u++) {
      // First buffalo
      final id1 = String.fromCharCode(65 + (u * 2));
      herd.add({
        'id': id1,
        'age': 5,
        'mature': true,
        'parentId': null,
        'generation': 0,
        'birthYear': _selectedYear - 5,
        'acquisitionMonth': _selectedMonth,
        'unit': u + 1,
      });
      
      // Second buffalo
      final id2 = String.fromCharCode(65 + (u * 2) + 1);
      herd.add({
        'id': id2,
        'age': 5,
        'mature': true,
        'parentId': null,
        'generation': 0,
        'birthYear': _selectedYear - 5,
        'acquisitionMonth': (_selectedMonth + 6) % 12,
        'unit': u + 1,
      });
    }
    
    // Simulate years
    for (int year = 1; year <= totalYears; year++) {
      final currentYear = _selectedYear + (year - 1);
      final matureBuffaloes = herd.where((b) => b['age'] >= 3).toList();
      
      // Each mature buffalo gives birth
      for (final parent in matureBuffaloes) {
        final parentId = parent['id'] as String;
        offspringCounts[parentId] = (offspringCounts[parentId] ?? 0) + 1;
        
        final newId = '$parentId${offspringCounts[parentId]}';
        
        herd.add({
          'id': newId,
          'age': 0,
          'mature': false,
          'parentId': parentId,
          'birthYear': currentYear,
          'acquisitionMonth': parent['acquisitionMonth'],
          'generation': parent['generation'] + 1,
          'unit': parent['unit'],
        });
      }
      
      // Age all buffaloes
      for (final buffalo in herd) {
        buffalo['age'] = buffalo['age'] + 1;
        if (buffalo['age'] >= 3) buffalo['mature'] = true;
      }
    }
    
    final revenueData = calculateRevenueData(herd, totalYears);
    
    return {
      'units': _units,
      'years': totalYears,
      'startYear': _selectedYear,
      'startMonth': _selectedMonth,
      'totalBuffaloes': herd.length,
      'buffaloes': herd,
      'revenueData': revenueData
    };
  }
  
  // Calculate CPF cost
  Map<int, double> calculateYearlyCPFCost(List<Map<String, dynamic>> buffaloes) {
    final cpfCostByYear = <int, double>{};
    const cpfPerMonth = 13000 / 12;
    
    for (int year = _selectedYear; year <= _selectedYear + 10; year++) {
      double totalCPFCost = 0;
      
      for (int unit = 1; unit <= _units; unit++) {
        double unitCPFCost = 0;
        final unitBuffaloes = buffaloes.where((buffalo) => buffalo['unit'] == unit).toList();
        
        for (final buffalo in unitBuffaloes) {
          int monthsWithCPF = 0;
          
          for (int month = 0; month < 12; month++) {
            bool isCpfApplicable = false;
            
            if (buffalo['id'] == 'A') {
              isCpfApplicable = true;
            } else if (buffalo['id'] == 'B') {
              // Free Period: July 2026 to June 2027
              final isPresent = year > buffalo['birthYear'] || 
                (year == buffalo['birthYear'] && month >= buffalo['acquisitionMonth']);
              
              if (isPresent) {
                final isFreePeriod = (year == _selectedYear && month >= 6) || 
                  (year == _selectedYear + 1 && month <= 5);
                
                if (!isFreePeriod) {
                  isCpfApplicable = true;
                }
              }
            } else if (buffalo['generation'] >= 1) {
              // Child CPF: Age >= 36 months
              final ageInMonths = calculateAgeInMonths(buffalo, year, month);
              if (ageInMonths >= 36) {
                isCpfApplicable = true;
              }
            }
            
            if (isCpfApplicable) {
              monthsWithCPF++;
            }
          }
          
          unitCPFCost += monthsWithCPF * cpfPerMonth;
        }
        
        totalCPFCost += unitCPFCost;
      }
      
      cpfCostByYear[year] = totalCPFCost;
    }
    
    return cpfCostByYear;
  }
  
  int calculateAgeInMonths(Map<String, dynamic> buffalo, int targetYear, int targetMonth) {
  final birthYear = buffalo['birthYear'] as int;
  final birthMonth = buffalo['acquisitionMonth'] as int;
  final totalMonths = (targetYear - birthYear) * 12 + (targetMonth - birthMonth);
  return totalMonths > 0 ? totalMonths : 0;
}
  
  // Format currency
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
  
  // Format number
  String formatNumber(int number) {
    return NumberFormat.decimalPattern().format(number);
  }
  
  @override
  Widget build(BuildContext context) {
    final treeData = runSimulation();
    final revenueData = treeData['revenueData'] as Map<String, dynamic>;
    final yearlyData = revenueData['yearlyData'] as List<Map<String, dynamic>>;
    final buffaloes = treeData['buffaloes'] as List<Map<String, dynamic>>;
    final yearlyCPFCost = calculateYearlyCPFCost(buffaloes);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Top Bar with Units and Year
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Unit Display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F9FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF0EA5E9), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.account_tree, size: 20, color: Color(0xFF0EA5E9)),
                      const SizedBox(width: 8),
                      Text(
                        'Units: $_units',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0EA5E9),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Year Selector
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20, color: Color(0xFF64748B)),
                        const SizedBox(width: 8),
                        const Text(
                          'Year:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _selectedYear,
                          underline: const SizedBox(),
                          items: List.generate(10, (index) => 2026 + index)
                              .map((year) => DropdownMenuItem(
                                    value: year,
                                    child: Text(
                                      year.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedYear = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Month Selector (only for Monthly Revenue)
                if (_selectedTab == 1) ...[
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range, size: 20, color: Color(0xFF64748B)),
                        const SizedBox(width: 8),
                        const Text(
                          'Month:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _selectedMonth,
                          underline: const SizedBox(),
                          items: monthNames.asMap().entries.map((entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMonth = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Tab Buttons
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _tabTitles.asMap().entries.map((entry) {
                  final index = entry.key;
                  final title = entry.value;
                  final isSelected = _selectedTab == index;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedTab = index;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? const Color(0xFF10B981) : const Color(0xFF1E293B),
                        foregroundColor: isSelected ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: isSelected ? 4 : 0,
                        shadowColor: isSelected ? const Color(0xFF10B981).withOpacity(0.3) : null,
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Builder(
                builder: (context) {
                  switch (_selectedTab) {
                    case 0:
                      return AnnualRevenueWidget(
                        yearlyData: yearlyData,
                        yearlyCPFCost: yearlyCPFCost,
                        formatCurrency: formatCurrency,
                        formatNumber: formatNumber,
                      );
                    case 1:
                      return MonthlyRevenueWidget(
                        treeData: treeData,
                        selectedYear: _selectedYear,
                        selectedMonth: _selectedMonth,
                        monthNames: monthNames,
                        formatCurrency: formatCurrency,
                        calculateMonthlyRevenueForBuffalo: calculateMonthlyRevenueForBuffalo,
                      );
                    case 2:
                      return AssetMarketValueWidget(
                        treeData: treeData,
                        buffaloes: buffaloes,
                        selectedYear: _selectedYear,
                        getBuffaloValueByAge: getBuffaloValueByAge,
                        formatCurrency: formatCurrency,
                        calculateAgeInMonths: calculateAgeInMonths,
                        monthNames: monthNames,
                      );
                    case 3:
                      return RevenueBreakEvenWidget(
                        treeData: treeData,
                        yearlyData: yearlyData,
                        yearlyCPFCost: yearlyCPFCost,
                        formatCurrency: formatCurrency,
                        units: _units,
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}