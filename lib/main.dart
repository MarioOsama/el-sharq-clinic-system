import 'package:el_sharq_clinic/clinic_system.dart';
import 'package:el_sharq_clinic/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  runApp(ClinicSystem(appRouter: AppRouter()));
}
