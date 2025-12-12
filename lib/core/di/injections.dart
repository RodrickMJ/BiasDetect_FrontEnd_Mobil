import 'package:bias_detect/features/auth/data/datasource/service_auth.dart';
import 'package:bias_detect/features/auth/data/repository/auth_repository_impl.dart';
import 'package:bias_detect/features/auth/domain/repository/auth_repository.dart';
import 'package:bias_detect/features/auth/domain/usecase/login_usecase.dart';
import 'package:bias_detect/features/auth/domain/usecase/register_usecase.dart';
import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:bias_detect/features/auth/presentation/provider/register_provider.dart';
import 'package:bias_detect/features/chatbot/data/datasource/service_chat.dart';
import 'package:bias_detect/features/chatbot/data/datasource/local_storage_service.dart';
import 'package:bias_detect/features/chatbot/data/datasource/fcm_token_service.dart'; 
import 'package:bias_detect/features/chatbot/data/repository/chat_repository_impl.dart';
import 'package:bias_detect/features/chatbot/domain/repository/chat_respository.dart';
import 'package:bias_detect/features/chatbot/domain/usecase/chat_usecase.dart';
import 'package:bias_detect/features/chatbot/presentation/provider/chat_history_provider.dart';
import 'package:bias_detect/features/chatbot/presentation/provider/chat_provider.dart';
import 'package:bias_detect/features/home/data/service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

Future<void> configureDependecies() async {
  // HTTP Client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // FCM Token Service 
  getIt.registerLazySingleton<FcmTokenService>(() => FcmTokenService());

  // Local Storage 
  final localStorage = LocalStorageService();
  await localStorage.init();
  getIt.registerSingleton<LocalStorageService>(localStorage);

  // Auth
  getIt.registerLazySingleton<ServiceAuth>(
    () => ServiceAuthImpl(getIt<http.Client>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton(() => LoginUsecase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUsecase(getIt<AuthRepository>()));

  getIt.registerLazySingleton<LoginProvider>(
    () => LoginProvider(loginUseCase: getIt()),
  );

  getIt.registerLazySingleton<RegisterProvider>(
    () => RegisterProvider(registerUsecase: getIt()),
  );

  // Chatbot
  getIt.registerLazySingleton<ChatService>(
    () => ChatServiceImpl(getIt<http.Client>()),
  );

  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt<ChatService>()),
  );

  getIt.registerLazySingleton<ChatUsecase>(
    () => ChatUsecase(getIt<ChatRepository>()),
  );

  //  ChatProvider localStorage Y fcmTokenService
  getIt.registerLazySingleton<ChatProvider>(
    () => ChatProvider(
      usecase: getIt<ChatUsecase>(),
      localStorage: getIt<LocalStorageService>(),
      fcmTokenService: getIt<FcmTokenService>(), // 👈 NUEVO
    ),
  );

  getIt.registerSingleton<ChatProvider>(ChatProvider(
  usecase: getIt(),
  localStorage: getIt(),
  fcmTokenService: getIt(),
));

getIt.registerSingleton<ChatHistoryProvider>(ChatHistoryProvider(getIt<LocalStorageService>()));
}