import 'package:hive/hive.dart';

part 'analytics_model.g.dart';

@HiveType(typeId: 2)
class AnalyticsModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final String resultado;

  @HiveField(3)
  final int cantidadSesgos;

  @HiveField(4)
  final List<String> tiposSesgos;

  @HiveField(5)
  final bool tieneDistorsion;

  @HiveField(6)
  final String sentimiento;

  @HiveField(7)
  final double sentimientoScore;

  @HiveField(8)
  final int cantidadCoincidencias;

  // 🔥 NUEVOS CAMPOS del análisis completo
  @HiveField(9)
  final Map<String, dynamic>? documentSesgo;

  @HiveField(10)
  final Map<String, dynamic>? userSesgo;

  @HiveField(11)
  final Map<String, dynamic>? documentDistorsion;

  @HiveField(12)
  final List<String> keywords;

  @HiveField(13)
  final String? scrapedTitle;

  @HiveField(14)
  final String? scrapedUrl;

  @HiveField(15)
  final List<String> scrapedSegments;

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
    this.documentSesgo,
    this.userSesgo,
    this.documentDistorsion,
    this.keywords = const [],
    this.scrapedTitle,
    this.scrapedUrl,
    this.scrapedSegments = const [],
  });

  // 🔥 ACTUALIZADO: Crear desde el response COMPLETO del backend
  factory AnalyticsModel.fromMLResponse(Map<String, dynamic> response) {
    // Extraer datos del LLM (para métricas básicas)
    final llm = response['llm'] as Map<String, dynamic>? ?? {};
    final sesgosLlm = llm['sesgos_encontrados'] as List? ?? [];
    final coincidencias = llm['coincidencias'] as List? ?? [];

    // Extraer datos del análisis de bias
    final bias = response['bias'] as Map<String, dynamic>? ?? {};
    final analisis = bias['analisis'] as Map<String, dynamic>? ?? {};
    final scrapedContent = bias['scraped_content'] as Map<String, dynamic>? ?? {};

    // Extraer minería de datos
    final mineria = analisis['mineria'] as Map<String, dynamic>? ?? {};
    final sentiment = mineria['sentiment'] as Map<String, dynamic>? ?? {};
    final keywords = mineria['keywords'] as List? ?? [];

    // Extraer document_sesgo
    final documentSesgo = analisis['document_sesgo'] as Map<String, dynamic>?;
    final userSesgo = analisis['user_sesgo'] as Map<String, dynamic>?;
    final documentDistorsion = analisis['document_distorsion'] as Map<String, dynamic>?;

    // Extraer scraped_content
    final scrapedSegments = scrapedContent['segmentos_contenido'] as List? ?? [];
    final scrapedTexts = scrapedSegments
        .map((seg) => (seg as Map<String, dynamic>)['text'] as String? ?? '')
        .where((text) => text.isNotEmpty)
        .toList();

    // Determinar si tiene distorsión
    final veredicto = documentDistorsion?['veredicto'] as String? ?? '';
    final tieneDistorsion = veredicto.toLowerCase() == 'parcial' || 
                           veredicto.toLowerCase() == 'total';

    return AnalyticsModel(
      id: response['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      resultado: llm['resultado'] ?? '',
      cantidadSesgos: sesgosLlm.length,
      tiposSesgos: sesgosLlm.map((s) => s.toString()).toList(),
      tieneDistorsion: tieneDistorsion,
      sentimiento: sentiment['label'] ?? 'NEU',
      sentimientoScore: (sentiment['score'] as num?)?.toDouble() ?? 0.0,
      cantidadCoincidencias: coincidencias.length,
      // 🔥 NUEVOS DATOS
      documentSesgo: documentSesgo,
      userSesgo: userSesgo,
      documentDistorsion: documentDistorsion,
      keywords: keywords.map((k) => k.toString()).toList(),
      scrapedTitle: scrapedContent['title'] as String?,
      scrapedUrl: scrapedContent['url'] as String?,
      scrapedSegments: scrapedTexts,
    );
  }

  // 🔥 NUEVO: Obtener todos los sesgos del documento
  List<Map<String, dynamic>> get allDocumentBiases {
    final biases = <Map<String, dynamic>>[];
    
    if (documentSesgo != null) {
      final sesgosEncontrados = documentSesgo!['sesgos_encontrados'] as List? ?? [];
      for (var sesgo in sesgosEncontrados) {
        if (sesgo is Map<String, dynamic>) {
          biases.add(sesgo);
        }
      }
    }
    
    return biases;
  }

  // 🔥 NUEVO: Obtener todos los sesgos del usuario
  List<Map<String, dynamic>> get allUserBiases {
    final biases = <Map<String, dynamic>>[];
    
    if (userSesgo != null) {
      final sesgosEncontrados = userSesgo!['sesgos_encontrados'] as List? ?? [];
      for (var sesgo in sesgosEncontrados) {
        if (sesgo is Map<String, dynamic>) {
          biases.add(sesgo);
        }
      }
    }
    
    return biases;
  }

  // 🔥 NUEVO: Obtener contradicciones detectadas
  List<Map<String, dynamic>> get contradicciones {
    if (documentDistorsion == null) return [];
    
    final contradiccionesList = documentDistorsion!['contradicciones'] as List? ?? [];
    return contradiccionesList
        .map((c) => c as Map<String, dynamic>)
        .toList();
  }
}