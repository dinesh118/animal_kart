class UnitSelection {
  final String id;
  final String breedId;
  final String userId;
  final int buffaloCount;
  final int calfCount;
  final int numUnits;
  final String paymentStatus;
  final String paymentMode;
  final int baseUnitCost;
  final int cpfUnitCost;
  final bool withCpf;
  final int unitCost;
  final int totalCost;
  final DateTime? placedAt;

  UnitSelection({
    required this.id,
    required this.breedId,
    required this.userId,
    required this.buffaloCount,
    required this.calfCount,
    required this.numUnits,
    required this.paymentStatus,
    required this.paymentMode,
    required this.baseUnitCost,
    required this.cpfUnitCost,
    required this.withCpf,
    required this.unitCost,
    required this.totalCost,
    this.placedAt,
  });

  factory UnitSelection.fromJson(Map<String, dynamic> json) {
    return UnitSelection(
      id: json['id'] ?? '',
      breedId: json['breedId'] ?? '',
      userId: json['userId'] ?? '',
      buffaloCount: json['buffaloCount'] ?? 0,
      calfCount: json['calfCount'] ?? 0,
      numUnits: json['numUnits'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? '',
      paymentMode: json['paymentMode'] ?? '',
      baseUnitCost: json['baseUnitCost'] ?? 0,
      cpfUnitCost: json['cpfUnitCost'] ?? 0,
      withCpf: json['withCpf'] ?? false,
      unitCost: json['unitCost'] ?? 0,
      totalCost: json['totalCost'] ?? 0,
      placedAt: json['placedAt'] != null 
          ? DateTime.tryParse(json['placedAt']) 
          : null,
    );
  }
}