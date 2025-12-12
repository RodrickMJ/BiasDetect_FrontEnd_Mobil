import '../repository/chat_respository.dart';

class ChatUsecase {
  final ChatRepository repository;

  ChatUsecase(this.repository);

  Future<Map<String, dynamic>?> sendNoticeAnalysis({
    required String url,
    required String fcmToken,
    required String textUser,
  }) {
    return repository.sendNoticeAnalysis(
      url: url,
      fcmToken: fcmToken,
      textUser: textUser,
    );
  }

  Future<Map<String, dynamic>?> sendCommentAnalysis({
    required String fcmToken,
    required String textUser,
  }) {
    return repository.sendCommentAnalysis(
      fcmToken: fcmToken,
      textUser: textUser,
    );
  }

  Future<Map<String, dynamic>?> getAnalysisById(String analysisId) {
    return repository.getAnalysisById(analysisId);
  }
}