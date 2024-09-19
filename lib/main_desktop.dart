import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/clinic_system_desktop.dart';
import 'package:el_sharq_clinic/core/di/dependency_injection.dart';
import 'package:el_sharq_clinic/core/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
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

  // Initialize Sentry
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://dce18842c8416c46a9e283c8eec3b953@o4507978849779712.ingest.us.sentry.io/4507978857316352';
      options.tracesSampleRate = 0.01;
    },
    appRunner: () => runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: DesktopClinicSystem(appRouter: AppRouter()),
      ),
    ),
  );
}
