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

  static const List<String> clinicsList = [
    'Select Clinic',
    'Clinic 1',
    'Clinic 2'
  ];

  // Drawer Items
  static const List<DrawerItemModel> drawerItems = [
    DrawerItemModel(title: 'Dashboard', icon: Icons.dashboard_outlined),
    DrawerItemModel(title: 'Case History', icon: Icons.history),
    DrawerItemModel(title: 'Pet Owners', icon: Icons.people_outline),
    DrawerItemModel(title: 'Doctors', icon: Icons.person_outline),
    DrawerItemModel(title: 'Services', icon: Icons.medical_services_outlined),
    DrawerItemModel(title: 'Products', icon: Icons.shopping_bag_outlined),
    DrawerItemModel(title: 'Sales', icon: Icons.attach_money_outlined),
    DrawerItemModel(title: 'Settings', icon: Icons.settings_outlined),
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
}
