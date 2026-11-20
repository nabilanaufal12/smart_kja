import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/config/firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'data/services/firebase_service.dart';
import 'data/services/local_storage_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/sensor_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/dashboard_viewmodel.dart';
import 'viewmodels/history_viewmodel.dart';
import 'viewmodels/chart_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';
import 'views/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Custom Error Widget to surface any widget build failures
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: const Color(0xFFB00020),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Text(
              'UI Error:\n${details.exceptionAsString()}\n\n${details.stack}',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  };

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  // Initialize Local Storage
  final localStorageService = await LocalStorageService.init();

  // Services
  final firebaseService = AppFirebaseService();

  // Repositories
  final authRepository = AuthRepositoryImpl(firebaseService);
  final sensorRepository = SensorRepositoryImpl(
    firebaseService: firebaseService,
    localStorageService: localStorageService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(localStorageService),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(sensorRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryViewModel(sensorRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ChartViewModel(sensorRepository),
        ),
      ],
      child: const SmartKjaApp(),
    ),
  );
}

class SmartKjaApp extends StatelessWidget {
  const SmartKjaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<SettingsViewModel>();

    return MaterialApp(
      title: 'SMART KJA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsVm.themeMode,
      home: const SplashScreen(),
    );
  }
}
