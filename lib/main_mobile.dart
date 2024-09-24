import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/clinic_system_mobile.dart';
import 'package:el_sharq_clinic/core/di/dependency_injection.dart';
import 'package:el_sharq_clinic/core/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Easy Localization Initialization
  await EasyLocalization.ensureInitialized();

  // Dependencies Injection
  setupGetIt();

  if (!kReleaseMode) {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MobileClinicSystem(appRouter: AppRouter()),
      ),
    );
  }

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
        child: MobileClinicSystem(appRouter: AppRouter()),
      ),
    ),
  );
}
