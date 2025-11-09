import 'package:bias_detect/core/di/injections.dart';
import 'package:bias_detect/features/auth/presentation/provider/login_provider.dart';
import 'package:bias_detect/features/auth/presentation/provider/register_provider.dart';
import 'package:bias_detect/myapp.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await configureDependecies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<LoginProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<RegisterProvider>())
      ],
      child: const Myapp(),
    )
  );
}