import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/service_item_action_button.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/services_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    super.key,
    required this.service,
  });

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showServiceSheet(
        context,
        'Service Details',
        service: service,
        editable: false,
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: _buildDecoration(),
        padding: const EdgeInsets.all(10),
        child: _buildListTile(),
      ),
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
        service.icon,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          service.title,
          style: AppTextStyles.font16DarkGreyMedium,
        ),
      ),
      subtitle: Text(
        '${service.price} LE',
        style: AppTextStyles.font16DarkGreyMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: ServiceItemActionButton(service: service),
    );
  }
}
