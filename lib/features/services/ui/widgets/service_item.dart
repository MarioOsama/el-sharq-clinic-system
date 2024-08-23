import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/theming/assets.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/service_item_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    super.key,
    required this.title,
    required this.price,
  });

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: _buildDecoration(),
      padding: const EdgeInsets.all(10),
      child: _buildListTile(),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: AppColors.darkGrey.withOpacity(0.5),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.darkGrey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    );
  }

  ListTile _buildListTile() {
    return ListTile(
      horizontalTitleGap: 30.w,
      leading: Image.asset(
        Assets.assetsImagesPngDoubleMedicine,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: AppTextStyles.font16DarkGreyMedium,
        ),
      ),
      subtitle: Text(
        price,
        style: AppTextStyles.font14DarkGreyMedium,
      ),
      trailing: ServiceItemActionButton(id: 'SVC001'),
    );
  }
}
