class Estadistica {
  final int? id;
  final int habitoId;
  final int rachaActual;
  final int totalDiasCompletados;

  Estadistica({
    this.id,
    required this.habitoId,
    required this.rachaActual,
    required this.totalDiasCompletados,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habito_id': habitoId,
      'racha_actual': rachaActual,
      'total_dias_completados': totalDiasCompletados,
    };
  }

  factory Estadistica.fromMap(Map<String, dynamic> map) {
    return Estadistica(
      id: map['id'],
      habitoId: map['habito_id'],
      rachaActual: map['racha_actual'],
      totalDiasCompletados: map['total_dias_completados'],
    );
  }
}