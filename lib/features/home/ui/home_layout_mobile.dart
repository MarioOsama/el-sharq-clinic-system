import 'package:el_sharq_clinic/core/di/dependency_injection.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/dashboard_section_mobile.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/custom_app_bar_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileHomeLayout extends StatelessWidget {
  const MobileHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final MainCubit mainCubit = context.read<MainCubit>();

    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: const MobileCustomAppBar(),
      body: Center(
        child: BlocProvider(
          create: (context) => getIt<DashboardCubit>()
            ..setupSectionData(mainCubit.authData, mainCubit),
          child: const MobileDashboardSection(),
        ),
      ),
    );
  }
}
