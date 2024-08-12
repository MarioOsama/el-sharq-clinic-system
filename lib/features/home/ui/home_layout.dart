import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/custom_app_bar.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int selectedDrawerItemIndex = 0;

  final List<Widget> drawerItems = const [
    Text('Dashboard'),
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
      appBar: const CustomAppBar(userName: 'Admin'),
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
