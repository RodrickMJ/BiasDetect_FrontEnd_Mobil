import 'package:bias_detect/features/chatbot/domain/repository/chat_respository.dart';
import '../datasource/service_chat.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatService service;

  ChatRepositoryImpl(this.service);

  @override
  Future<Map<String, dynamic>?> sendNoticeAnalysis({
    required String url,
    required String fcmToken,
    required String textUser,
  }) {
    return service.sendNoticeAnalysis(
      url: url,
      fcmToken: fcmToken,
      textUser: textUser,
    );
  }

  @override
  Future<Map<String, dynamic>?> sendCommentAnalysis({
    required String fcmToken,
    required String textUser,
  }) {
    return service.sendCommentAnalysis(
      fcmToken: fcmToken,
      textUser: textUser,
    );
  }

  @override
  Future<Map<String, dynamic>?> getAnalysisById(String analysisId) {
    return service.getAnalysisById(analysisId);
  }
}