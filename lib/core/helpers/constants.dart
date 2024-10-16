import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/features/home/data/models/drawer_item_model.dart';
import 'package:flutter/material.dart';

abstract class AppConstant {
  static const String appName = 'El Sharq Clinic';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  static const String apiKey = "AIzaSyDaLY0H1ZcUigddp7tQZOekJ2232ncLlQQ";
  static const String appId = "el-sharq-clinic-system";

  static const List<String> languages = ['English', 'Arabic'];
  static const List<String> themes = ['Light', 'Dark'];

  static const String casesFirebaseCollectionName = 'cases';

  // Drawer Items
  static List<DrawerItemModel> drawerItems = const [
    DrawerItemModel(
        title: AppStrings.dashboard, icon: Icons.dashboard_outlined),
    DrawerItemModel(title: AppStrings.casesHistory, icon: Icons.history),
    DrawerItemModel(title: AppStrings.petOwners, icon: Icons.people_outline),
    DrawerItemModel(title: AppStrings.doctors, icon: Icons.person_outline),
    DrawerItemModel(
        title: AppStrings.services, icon: Icons.medical_services_outlined),
    DrawerItemModel(
        title: AppStrings.products, icon: Icons.shopping_bag_outlined),
    DrawerItemModel(
        title: AppStrings.invoices, icon: Icons.attach_money_outlined),
    DrawerItemModel(title: AppStrings.settings, icon: Icons.settings_outlined),
  ];

  // Dashboard
  static const dashboardSalesSectionsColorList = [
    AppColors.red,
    AppColors.blue,
    AppColors.green,
  ];

  // Case History
  static const List<String> casesTableHeaders = [
    AppStrings.caseId,
    AppStrings.ownerName,
    AppStrings.doctorId,
    AppStrings.phone,
    AppStrings.date,
    ''
  ];

  // Pet Owners
  static const List<String> ownersTableHeaders = [
    AppStrings.ownerId,
    AppStrings.ownerName,
    AppStrings.phone,
    AppStrings.numberOfPets,
    AppStrings.registrationDate,
    ''
  ];

  // Pets
  static const String petCaseReportScheme = """Diagnosis:
Temp:
Unique signs: 
R.R:
H.R:
B.W: ..... kg 
Vaccinations:
Treatment:""";

  static const String petProfileReportScheme = """Diagnosis:
Temp:
Unique signs: 
R.R:
H.R:""";

// Doctors
  static const List<String> doctorsTableHeaders = [
    AppStrings.doctorId,
    AppStrings.doctorName,
    AppStrings.phone,
    AppStrings.registrationDate,
    ''
  ];

  // Invoices
  static const List<String> invoicesTableHeaders = [
    AppStrings.invoiceId,
    AppStrings.totalLE,
    AppStrings.numberOfItems,
    AppStrings.date,
    AppStrings.time,
    AppStrings.discountLE,
    ''
  ];
}
