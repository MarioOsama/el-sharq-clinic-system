import 'package:el_sharq_clinic/core/di/dependency_injection.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/cases/logic/cubit/cases_cubit.dart';
import 'package:el_sharq_clinic/features/cases/ui/case_history_section.dart';
import 'package:el_sharq_clinic/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/dashboard_section.dart';
import 'package:el_sharq_clinic/features/doctors/logic/cubit/doctors_cubit.dart';
import 'package:el_sharq_clinic/features/doctors/ui/doctors_section.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/custom_app_bar.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/custom_drawer.dart';
import 'package:el_sharq_clinic/features/invoices/logic/cubit/invoices_cubit.dart';
import 'package:el_sharq_clinic/features/invoices/ui/invoices_section.dart';
import 'package:el_sharq_clinic/features/owners/logic/cubit/owners_cubit.dart';
import 'package:el_sharq_clinic/features/owners/ui/owners_section.dart';
import 'package:el_sharq_clinic/features/products/logic/cubit/products_cubit.dart';
import 'package:el_sharq_clinic/features/products/ui/products_section.dart';
import 'package:el_sharq_clinic/features/services/logic/cubit/services_cubit.dart';
import 'package:el_sharq_clinic/features/services/ui/services_section.dart';
import 'package:el_sharq_clinic/features/settings/logic/cubit/settings_cubit.dart';
import 'package:el_sharq_clinic/features/settings/ui/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int selectedDrawerItemIndex = 0;
  late AuthDataModel authData;

  @override
  void initState() {
    super.initState();
    authData = context.read<MainCubit>().authData;
  }

  @override
  Widget build(BuildContext context) {
    final List drawerItems = _getDrawerWidgets;
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: const CustomAppBar(),
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
            ),
          ),
          Expanded(
            flex: 6,
            child: LayoutBuilder(builder: (context, constraints) {
              return drawerItems[selectedDrawerItemIndex](context);
            }),
          ),
        ],
      ),
    );
  }

  /// List of widget builders that will be displayed in the drawer
  List<WidgetBuilder> get _getDrawerWidgets {
    //TODO: Remove all log statements
    final MainCubit mainCubit = context.read<MainCubit>();

    return [
      (context) => BlocProvider(
            create: (context) => getIt<DashboardCubit>()
              ..setupSectionData(mainCubit.authData, mainCubit),
            child: const DashboardSection(),
          ),
      (context) => BlocProvider<CasesCubit>(
            create: (context) =>
                getIt<CasesCubit>()..setupSectionData(mainCubit.authData),
            child: const CaseHistorySection(),
          ),
      (context) => BlocProvider<OwnersCubit>(
            create: (context) =>
                getIt<OwnersCubit>()..setupSectionData(mainCubit.authData),
            child: const OwnersSection(),
          ),
      (context) => BlocProvider<DoctorsCubit>(
            create: (context) =>
                getIt<DoctorsCubit>()..setupSectionData(mainCubit.authData),
            child: const DoctorsSection(),
          ),
      (context) => BlocProvider<ServicesCubit>(
            create: (context) => getIt<ServicesCubit>()
              ..setupSectionData(mainCubit.authData, context),
            child: const ServicesSection(),
          ),
      (context) => BlocProvider<ProductsCubit>(
            create: (context) => getIt<ProductsCubit>()
              ..setupSectionData(mainCubit.authData, context),
            child: const ProductsSection(),
          ),
      (context) => BlocProvider<InvoicesCubit>(
            create: (context) => getIt<InvoicesCubit>()
              ..setupSectionData(mainCubit.authData, context),
            child: const InvoicesSection(),
          ),
      (context) => BlocProvider<SettingsCubit>(
            create: (context) =>
                getIt<SettingsCubit>()..setupSectionData(mainCubit.authData),
            child: const SettingsSection(),
          ),
    ];
  }
}
