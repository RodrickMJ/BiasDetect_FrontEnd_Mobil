import 'package:hive/hive.dart';

part 'analytics_model.g.dart';

@HiveType(typeId: 2)
class AnalyticsModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final String resultado; // "CON SESGOS DETECTADOS" o "SIN SESGOS DETECTADOS"

  @HiveField(3)
  final int cantidadSesgos;

  @HiveField(4)
  final List<String> tiposSesgos;

  @HiveField(5)
  final bool tieneDistorsion;

  @HiveField(6)
  final String sentimiento; // "POS", "NEG", "NEU"

  @HiveField(7)
  final double sentimientoScore;

  @HiveField(8)
  final int cantidadCoincidencias;

  AnalyticsModel({
    required this.id,
    required this.timestamp,
    required this.resultado,
    required this.cantidadSesgos,
    required this.tiposSesgos,
    required this.tieneDistorsion,
    required this.sentimiento,
    required this.sentimientoScore,
    required this.cantidadCoincidencias,
  });

  // Crear desde el response del ML
  factory AnalyticsModel.fromMLResponse(Map<String, dynamic> response) {
    final sesgos = response['sesgos_encontrados'] as List? ?? [];
    final coincidencias = response['coincidencias'] as List? ?? [];

    return AnalyticsModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      resultado: response['resultado'] ?? '',
      cantidadSesgos: sesgos.length,
      tiposSesgos: sesgos.map((s) => s.toString()).toList(),
      tieneDistorsion: response['resultado']?.toString().contains('DISTORSION') ?? false,
      sentimiento: 'NEU', // Por defecto
      sentimientoScore: 0.0,
      cantidadCoincidencias: coincidencias.length,
    );
  }
}