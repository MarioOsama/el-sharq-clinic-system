import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/features/home/ui/widgets/drawer_item.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer(
      {super.key, required this.onItemTap, required this.currentSelectedIndex});

  final Function(int index) onItemTap;
  final int currentSelectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildContainerDecoration(),
      child: Drawer(
        backgroundColor: AppColors.white,
        shape: const BeveledRectangleBorder(),
        child: ListView(
          children: [
            verticalSpace(50),
            ..._buildDrawerItemsList(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return const BoxDecoration(
        border: Border(
      right: BorderSide(
        color: AppColors.grey,
        width: 0.5,
      ),
    ));
  }

  _buildDrawerItemsList() {
    final drawerItems = AppConstant.drawerItems;
    return List.generate(drawerItems.length, (index) {
      return GestureDetector(
        onTap: () {
          onItemTap(index);
        },
        child: DrawerItem(
          drawerItemModel: drawerItems[index],
          isSelected: index == currentSelectedIndex,
        ),
      );
    });
  }
}
