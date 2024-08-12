import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/dashboard_section.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/custom_app_bar.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key, required this.authData});

  final AuthDataModel authData;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int selectedDrawerItemIndex = 0;

  final List<Widget> drawerItems = const [
    DashboardSection(),
    Text('Appointments'),
    Text('Pet Owners'),
    Text('Services'),
    Text('Products'),
    Text('Sales'),
    Text('Settings'),
  ];

  @override
  Widget build(BuildContext context) {
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
              child: drawerItems[selectedDrawerItemIndex],
            ),
          ),
        ],
      ),
    );
  }
}
