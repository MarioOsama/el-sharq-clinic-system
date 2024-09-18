import 'package:el_sharq_clinic/clinic_system_mobile.dart';
import 'package:el_sharq_clinic/core/di/dependency_injection.dart';
import 'package:el_sharq_clinic/core/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Dependencies Injection
  setupGetIt();

  runApp(
    MobileClinicSystem(appRouter: AppRouter()),
  );
}
