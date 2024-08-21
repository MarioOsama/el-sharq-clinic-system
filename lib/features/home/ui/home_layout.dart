import 'package:el_sharq_clinic/core/di/dependency_injection.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/cases/logic/cubit/case_history_cubit.dart';
import 'package:el_sharq_clinic/features/cases/ui/case_history_section.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/dashboard_section.dart';
import 'package:el_sharq_clinic/features/doctors/logic/cubit/doctors_cubit.dart';
import 'package:el_sharq_clinic/features/doctors/ui/doctors_section.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/custom_app_bar.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/custom_drawer.dart';
import 'package:el_sharq_clinic/features/owners/logic/cubit/owners_cubit.dart';
import 'package:el_sharq_clinic/features/owners/ui/owners_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key, required this.authData});

  final AuthDataModel authData;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int selectedDrawerItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List drawerItems = _getDrawerWidgets;
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: CustomAppBar(userName: widget.authData.userModel.userName),
      body: Row(
        children: [
          Expanded(
              child: CustomDrawer(
            currentSelectedIndex: selectedDrawerItemIndex,
            onItemTap: (index) {
              setState(() {
                selectedDrawerItemIndex = index;
              });
            },
          )),
          Expanded(
            flex: 5,
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return drawerItems[selectedDrawerItemIndex](context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// List of widget builders that will be displayed in the drawer
  List<WidgetBuilder> get _getDrawerWidgets {
    return [
      (context) => DashboardSection(authData: widget.authData),
      (context) => BlocProvider<CaseHistoryCubit>(
            create: (context) =>
                getIt<CaseHistoryCubit>()..setupSectionData(widget.authData),
            child: CaseHistorySection(authData: widget.authData),
          ),
      (context) => BlocProvider<OwnersCubit>(
            create: (context) =>
                getIt<OwnersCubit>()..setupSectionData(widget.authData),
            child: OwnersSection(authData: widget.authData),
          ),
      (context) => BlocProvider<DoctorsCubit>(
            create: (context) => getIt<DoctorsCubit>(),
            child: const DoctorsSection(),
          ),
      // const Text('Pet Owners'),
      // const Text('Services'),
      // const Text('Products'),
      // const Text('Sales'),
      // const Text('Settings'),
    ];
  }
}
