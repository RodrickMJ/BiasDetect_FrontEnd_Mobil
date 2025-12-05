import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/conversation_model.dart';
import '../models/analytics_model.dart';
import '../../domain/entities/chat.dart';

class LocalStorageService {
  static const String _conversationsBox = 'conversations';
  static const String _analyticsBox = 'analytics';

  Box<ConversationModel>? _conversationsBoxRef;
  Box<AnalyticsModel>? _analyticsBoxRef;

  Future<void> init() async {
    await Hive.initFlutter();

    // Registrar adaptadores
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ConversationModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ChatMessageModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AnalyticsModelAdapter());
    }

    // Abrir boxes
    _conversationsBoxRef = await Hive.openBox<ConversationModel>(
      _conversationsBox,
    );
    _analyticsBoxRef = await Hive.openBox<AnalyticsModel>(_analyticsBox);
  }

  // ==================== CONVERSACIONES ====================

  Future<String> saveConversation({
    required String title,
    required List<ChatMessage> messages,
    String? url,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final conversation = ConversationModel(
      id: id,
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      messages: messages.map((m) => ChatMessageModel.fromEntity(m)).toList(),
      url: url,
    );

    await _conversationsBoxRef?.put(id, conversation);
    return id;
  }

  Future<void> updateConversation({
    required String id,
    List<ChatMessage>? messages,
    String? url,
  }) async {
    final existing = _conversationsBoxRef?.get(id);
    if (existing == null) return;

    final updated = ConversationModel(
      id: existing.id,
      title: existing.title,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
      messages:
          messages?.map((m) => ChatMessageModel.fromEntity(m)).toList() ??
          existing.messages,
      url: url ?? existing.url,
    );

    await _conversationsBoxRef?.put(id, updated);
  }

  List<ConversationModel> getAllConversations() {
    final conversations = _conversationsBoxRef?.values.toList() ?? [];
    conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return conversations;
  }

  ConversationModel? getConversation(String id) {
    return _conversationsBoxRef?.get(id);
  }

  Future<void> deleteConversation(String id) async {
    await _conversationsBoxRef?.delete(id);
  }

  Future<void> clearAll() async {
    await _conversationsBoxRef?.clear();
  }

  Map<String, List<ConversationModel>> getGroupedConversations() {
    final conversations = getAllConversations();
    final Map<String, List<ConversationModel>> grouped = {};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final lastWeek = today.subtract(const Duration(days: 7));

    for (var conv in conversations) {
      final convDate = DateTime(
        conv.updatedAt.year,
        conv.updatedAt.month,
        conv.updatedAt.day,
      );

      String group;
      if (convDate == today) {
        group = 'Hoy';
      } else if (convDate == yesterday) {
        group = 'Ayer';
      } else if (convDate.isAfter(lastWeek)) {
        group = 'Esta semana';
      } else if (convDate.isAfter(today.subtract(const Duration(days: 30)))) {
        group = 'Este mes';
      } else {
        group = 'Anteriores';
      }

      grouped.putIfAbsent(group, () => []);
      grouped[group]!.add(conv);
    }

    return grouped;
  }

  // ==================== ANALYTICS ====================

  Future<void> saveAnalytics(AnalyticsModel analytics) async {
    await _analyticsBoxRef?.put(analytics.id, analytics);
  }

  List<AnalyticsModel> getAllAnalytics() {
    final analytics = _analyticsBoxRef?.values.toList() ?? [];
    analytics.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return analytics;
  }

  List<AnalyticsModel> getAnalyticsByDateRange(DateTime start, DateTime end) {
    final all = getAllAnalytics();
    return all.where((a) {
      return a.timestamp.isAfter(start) && a.timestamp.isBefore(end);
    }).toList();
  }

  // Métricas calculadas
  Map<String, dynamic> getMetrics() {
    final all = getAllAnalytics();

    if (all.isEmpty) {
      return {
        'totalAnalisis': 0,
        'conSesgos': 0,
        'sinSesgos': 0,
        'porcentajeSesgos': 0.0,
        'sesgosMasComunes': <String>[],
        'sentimientoPromedio': 0.0,
      };
    }

    final conSesgos = all.where((a) => a.cantidadSesgos > 0).length;
    final sinSesgos = all.length - conSesgos;

    // Contar sesgos más comunes
    final Map<String, int> sesgosCounts = {};
    for (var a in all) {
      for (var sesgo in a.tiposSesgos) {
        sesgosCounts[sesgo] = (sesgosCounts[sesgo] ?? 0) + 1;
      }
    }

    final sesgosMasComunes = sesgosCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'totalAnalisis': all.length,
      'conSesgos': conSesgos,
      'sinSesgos': sinSesgos,
      'porcentajeSesgos': (conSesgos / all.length * 100).toStringAsFixed(1),
      'sesgosMasComunes': sesgosMasComunes.take(3).map((e) => e.key).toList(),
      'promedioSesgos':
          (all.fold<int>(0, (sum, a) => sum + a.cantidadSesgos) / all.length)
              .toStringAsFixed(1),
    };
  }

  // Datos para la gráfica de progreso (últimos 7 días)
  List<Map<String, dynamic>> getWeeklyProgress() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> weekData = [];

    for (int i = 6; i >= 0; i--) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      final nextDate = date.add(const Duration(days: 1));

      final dayAnalytics = getAllAnalytics().where((a) {
        return a.timestamp.isAfter(date) && a.timestamp.isBefore(nextDate);
      }).toList();

      weekData.add({
        'day': _getDayName(date.weekday),
        'count': dayAnalytics.length,
        'withBias': dayAnalytics.where((a) => a.cantidadSesgos > 0).length,
      });
    }

    return weekData;
  }

  String _getDayName(int weekday) {
    const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    return days[weekday - 1];
  }

  // ==================== RECOMENDACIONES ====================

  List<String> getPersonalizedRecommendations() {
    final metrics = getMetrics();
    final all = getAllAnalytics();
    final recommendations = <String>[];

    final totalAnalisis = metrics['totalAnalisis'] as int;
    final porcentajeSesgos =
        double.tryParse(metrics['porcentajeSesgos'].toString()) ?? 0;
    final sesgosMasComunes = metrics['sesgosMasComunes'] as List<String>;

    // Recomendación basada en cantidad de análisis
    if (totalAnalisis == 0) {
      recommendations.add(
        '📝 Realiza tu primer análisis para comenzar a detectar sesgos cognitivos',
      );
    } else if (totalAnalisis < 5) {
      recommendations.add(
        '🎯 Continúa analizando para obtener estadísticas más precisas',
      );
    }

    // Recomendación basada en porcentaje de sesgos
    if (porcentajeSesgos > 70) {
      recommendations.add(
        '⚠️ Alto índice de sesgos detectados. Revisa tus fuentes de información',
      );
    } else if (porcentajeSesgos > 40) {
      recommendations.add(
        '💡 Considera contrastar información de múltiples fuentes',
      );
    } else if (porcentajeSesgos < 20 && totalAnalisis > 5) {
      recommendations.add(
        '✅ Excelente pensamiento crítico. Mantén este nivel de análisis',
      );
    }

    // Recomendaciones según sesgos más comunes
    if (sesgosMasComunes.isNotEmpty) {
      final sesgoTop = sesgosMasComunes.first.toLowerCase();

      if (sesgoTop.contains('confirmación')) {
        recommendations.add(
          '🔍 Sesgo de confirmación detectado frecuentemente. Busca evidencia que contradiga tus creencias',
        );
      } else if (sesgoTop.contains('autoridad')) {
        recommendations.add(
          '👤 Frecuente apelación a la autoridad. Verifica las fuentes independientemente de quién las diga',
        );
      } else if (sesgoTop.contains('anclaje')) {
        recommendations.add(
          '⚓ Sesgo de anclaje común. No te quedes con la primera información que recibes',
        );
      } else if (sesgoTop.contains('generalización')) {
        recommendations.add(
          '📊 Evita generalizar casos particulares. Busca datos estadísticos',
        );
      }
    }

    // Recomendación de progreso
    if (all.length > 10) {
      final lastWeek = all.take(7).where((a) => a.cantidadSesgos > 0).length;
      final previousWeek = all
          .skip(7)
          .take(7)
          .where((a) => a.cantidadSesgos > 0)
          .length;

      if (lastWeek < previousWeek) {
        recommendations.add(
          '📈 Has mejorado tu pensamiento crítico esta semana',
        );
      } else if (lastWeek > previousWeek) {
        recommendations.add(
          '📉 Más sesgos detectados esta semana. Mantén el enfoque crítico',
        );
      }
    }

    return recommendations.isEmpty
        ? [
            '👋 ¡Bienvenido! Comienza a analizar textos para recibir recomendaciones personalizadas',
          ]
        : recommendations;
  }

  // ==================== EJEMPLOS DE SESGOS ====================

  List<Map<String, dynamic>> getBiasExamples() {
    return [
      {
        'nombre': 'Sesgo de Confirmación',
        'descripcion':
            'Tendencia a buscar o interpretar información que confirma creencias previas',
        'ejemplo':
            '"Sabía que ese político era corrupto, mira esta noticia que lo confirma"',
        'como_evitarlo':
            'Busca activamente información que contradiga tus creencias',
        'icono': Icons.search,
        'color': Colors.blue,
      },
      {
        'nombre': 'Apelación a la Autoridad',
        'descripcion':
            'Aceptar algo como verdad solo porque lo dice una figura de autoridad',
        'ejemplo': '"El presidente lo dijo, así que debe ser cierto"',
        'como_evitarlo':
            'Verifica las afirmaciones independientemente de quién las haga',
        'icono': Icons.person,
        'color': Colors.orange,
      },
      {
        'nombre': 'Sesgo de Anclaje',
        'descripcion': 'Confiar demasiado en la primera información recibida',
        'ejemplo':
            '"El primer precio que vi era \$100, así que \$80 es una ganga"',
        'como_evitarlo':
            'Recopila múltiples puntos de referencia antes de decidir',
        'icono': Icons.anchor,
        'color': Colors.purple,
      },
      {
        'nombre': 'Generalización Apresurada',
        'descripcion': 'Llegar a conclusiones basándose en pocos casos',
        'ejemplo':
            '"Conozco dos personas de ese país y son deshonestas, todos deben serlo"',
        'como_evitarlo': 'Busca datos estadísticos y muestras representativas',
        'icono': Icons.people,
        'color': Colors.red,
      },
      {
        'nombre': 'Falsa Causa',
        'descripcion':
            'Asumir que porque dos eventos ocurren juntos, uno causa al otro',
        'ejemplo': '"Siempre que uso esta camisa, mi equipo gana"',
        'como_evitarlo': 'Distingue entre correlación y causalidad',
        'icono': Icons.link_off,
        'color': Colors.green,
      },
      {
        'nombre': 'Efecto Halo',
        'descripcion':
            'Juzgar todo sobre algo basándose en una sola característica positiva',
        'ejemplo': '"Es atractivo, debe ser inteligente y honesto también"',
        'como_evitarlo': 'Evalúa cada aspecto de forma independiente',
        'icono': Icons.star,
        'color': Colors.amber,
      },
    ];
  }

  // ==================== ESTADÍSTICAS DETALLADAS ====================

  // Distribución de cantidad de sesgos por análisis
  Map<int, int> getBiasDistribution() {
    final all = getAllAnalytics();
    final Map<int, int> distribution = {};

    for (var a in all) {
      distribution[a.cantidadSesgos] =
          (distribution[a.cantidadSesgos] ?? 0) + 1;
    }

    return distribution;
  }

  // Top 5 sesgos más comunes
  List<Map<String, dynamic>> getTopBiases() {
    final all = getAllAnalytics();
    final Map<String, int> biasCount = {};

    for (var a in all) {
      for (var bias in a.tiposSesgos) {
        biasCount[bias] = (biasCount[bias] ?? 0) + 1;
      }
    }

    final sorted = biasCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(5)
        .map(
          (e) => {
            'nombre': e.key,
            'cantidad': e.value,
            'porcentaje': all.isEmpty
                ? 0.0
                : (e.value / all.length * 100).toStringAsFixed(1),
          },
        )
        .toList();
  }

  // Análisis de sentimiento promedio
  Map<String, dynamic> getSentimentAnalysis() {
    final all = getAllAnalytics();

    if (all.isEmpty) {
      return {'promedio': 0.0, 'positivos': 0, 'negativos': 0, 'neutrales': 0};
    }

    int positivos = 0;
    int negativos = 0;
    int neutrales = 0;
    double sumaScores = 0;

    for (var a in all) {
      sumaScores += a.sentimientoScore;

      if (a.sentimiento == 'POS')
        positivos++;
      else if (a.sentimiento == 'NEG')
        negativos++;
      else
        neutrales++;
    }

    return {
      'promedio': (sumaScores / all.length).toStringAsFixed(2),
      'positivos': positivos,
      'negativos': negativos,
      'neutrales': neutrales,
    };
  }

  // Tendencias mensuales (últimos 6 meses)
  List<Map<String, dynamic>> getMonthlyTrends() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> trends = [];

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final nextMonth = DateTime(now.year, now.month - i + 1, 1);

      final monthAnalytics = getAllAnalytics().where((a) {
        return a.timestamp.isAfter(month) && a.timestamp.isBefore(nextMonth);
      }).toList();

      trends.add({
        'mes': _getMonthName(month.month),
        'total': monthAnalytics.length,
        'conSesgos': monthAnalytics.where((a) => a.cantidadSesgos > 0).length,
        'sinSesgos': monthAnalytics.where((a) => a.cantidadSesgos == 0).length,
      });
    }

    return trends;
  }

  String _getMonthName(int month) {
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return months[month - 1];
  }

  // Últimos 10 análisis
  List<Map<String, dynamic>> getRecentAnalyses() {
    final all = getAllAnalytics();
    return all
        .take(10)
        .map(
          (a) => {
            'id': a.id,
            'timestamp': a.timestamp,
            'resultado': a.resultado,
            'cantidadSesgos': a.cantidadSesgos,
            'tiposSesgos': a.tiposSesgos,
          },
        )
        .toList();
  }
}
