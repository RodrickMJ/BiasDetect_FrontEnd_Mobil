import 'package:bias_detect/features/auth/data/datasource/service_auth.dart';
import 'package:bias_detect/features/auth/data/repository/auth_repository_impl.dart';
import 'package:bias_detect/features/auth/domain/repository/auth_repository.dart';
import 'package:bias_detect/features/auth/domain/usecase/login_usecase.dart';
import 'package:bias_detect/features/auth/domain/usecase/register_usecase.dart';
import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:bias_detect/features/auth/presentation/provider/register_provider.dart';
import 'package:bias_detect/features/chatbot/data/datasource/service_chat.dart';
import 'package:bias_detect/features/chatbot/data/repository/chat_repository_impl.dart';
import 'package:bias_detect/features/chatbot/domain/repository/chat_respository.dart';
import 'package:bias_detect/features/chatbot/domain/usecase/chat_usecase.dart';
import 'package:bias_detect/features/chatbot/presentation/provider/chat_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final getIt = GetIt.instance;

Future<void> configureDependecies() async {
  getIt.registerLazySingleton<http.Client>(() => http.Client());

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

  getIt.registerLazySingleton<ChatProvider>(
    () => ChatProvider(usecase: getIt()),
  );
}
