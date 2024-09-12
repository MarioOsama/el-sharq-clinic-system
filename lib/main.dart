import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/clinic_system.dart';
import 'package:el_sharq_clinic/core/di/dependency_injection.dart';
import 'package:el_sharq_clinic/core/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDaLY0H1ZcUigddp7tQZOekJ2232ncLlQQ",
        authDomain: "el-sharq-clinic-system.firebaseapp.com",
        projectId: "el-sharq-clinic-system",
        storageBucket: "el-sharq-clinic-system.appspot.com",
        messagingSenderId: "308772479666",
        appId: "1:308772479666:web:44939be9741aee30a31fab"),
  );

  // Easy Localization Initialization
  await EasyLocalization.ensureInitialized();

  // Dependencies Injection
  setupGetIt();

  // Window Manager
  await windowManager.ensureInitialized();

  Display primaryDisplay = await screenRetriever.getPrimaryDisplay();
  double displayWidth = primaryDisplay.size.width;
  double displayHeight = primaryDisplay.size.height;

  WindowOptions windowOptions = WindowOptions(
    title: 'El Sharq Clinic',
    titleBarStyle: TitleBarStyle.normal,
    center: true,
    size: Size(displayWidth, displayHeight - displayHeight),
    minimumSize: Size(
        displayWidth - displayWidth * 0.1, displayHeight - displayHeight * 0.1),
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar'),
      child: ClinicSystem(appRouter: AppRouter()),
    ),
  );
}
