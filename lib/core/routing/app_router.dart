import 'package:el_sharq_clinic/core/di/dependency_injection.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/routing/app_routes.dart';
import 'package:el_sharq_clinic/core/widgets/connectivity_monitor.dart';
import 'package:el_sharq_clinic/features/auth/logic/cubit/auth_cubit.dart';
import 'package:el_sharq_clinic/features/auth/ui/auth_screen.dart';
import 'package:el_sharq_clinic/features/home/ui/home_layout.dart';
import 'package:el_sharq_clinic/features/home/ui/home_layout_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    // Arguments to be passed to any screen like this : (arguments as ClassName)
    final arguments = settings.arguments;

    switch (settings.name) {
      case AppRoutes.auth:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthCubit>(
            create: (context) => getIt<AuthCubit>()..setupInitialData(),
            child: const ConnectivityMonitor(child: AuthScreen()),
          ),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<MainCubit>(
            create: (context) => getIt<MainCubit>()
              ..setupInitialData(arguments as AuthDataModel),
            child: const ConnectivityMonitor(child: HomeLayout()),
          ),
        );
      case AppRoutes.homeMobile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<MainCubit>(
            create: (context) => getIt<MainCubit>()
              ..setupInitialData(arguments as AuthDataModel),
            child: const ConnectivityMonitor(child: MobileHomeLayout()),
          ),
        );
      default:
        return null;
    }
  }
}
