abstract class ChatRepository {

  Future<Map<String, dynamic>?> sendNoticeAnalysis({
    required String url,
    required String fcmToken,
    required String textUser,
  });


  Future<Map<String, dynamic>?> sendCommentAnalysis({
    required String fcmToken,
    required String textUser,
  });

 
  Future<Map<String, dynamic>?> getAnalysisById(String analysisId);
}