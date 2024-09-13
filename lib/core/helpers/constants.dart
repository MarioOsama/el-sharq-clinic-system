import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
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

  // Drawer Items
  static List<DrawerItemModel> drawerItems = [
    DrawerItemModel(
        title: AppStrings.dashboard.tr(), icon: Icons.dashboard_outlined),
    DrawerItemModel(title: AppStrings.casesHistory.tr(), icon: Icons.history),
    DrawerItemModel(
        title: AppStrings.petOwners.tr(), icon: Icons.people_outline),
    DrawerItemModel(title: AppStrings.doctors.tr(), icon: Icons.person_outline),
    DrawerItemModel(
        title: AppStrings.services.tr(), icon: Icons.medical_services_outlined),
    DrawerItemModel(
        title: AppStrings.products.tr(), icon: Icons.shopping_bag_outlined),
    DrawerItemModel(
        title: AppStrings.invoices.tr(), icon: Icons.attach_money_outlined),
    DrawerItemModel(
        title: AppStrings.settings.tr(), icon: Icons.settings_outlined),
  ];

  // Case History
  static const List<String> casesTableHeaders = [
    'Case ID',
    'Owner Name',
    'Doctor ID',
    'Phone',
    'Date',
    ''
  ];

  // Pet Owners
  static const List<String> ownersTableHeaders = [
    'Owner ID',
    'Owner Name',
    'Phone',
    'Number of Pets',
    'Registration Date',
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
    'Doctor ID',
    'Doctor Name',
    'Phone',
    'Registration Date',
    ''
  ];

  // Invoices
  static const List<String> invoicesTableHeaders = [
    'Invoice ID',
    'Total (LE)',
    'Number of Items',
    'Date',
    'Time',
    'Discount (LE)',
    ''
  ];
}
