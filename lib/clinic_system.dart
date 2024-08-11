import 'package:el_sharq_clinic/core/routing/app_router.dart';
import 'package:el_sharq_clinic/core/routing/app_routes.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClinicSystem extends StatelessWidget {
  final AppRouter appRouter;
  const ClinicSystem({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 1024),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Clinic System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
          useMaterial3: true,
        ),
        onGenerateRoute: appRouter.onGenerateRoute,
        initialRoute: AppRoutes.auth,
      ),
    );
  }
}
