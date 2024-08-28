import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvoiceNewItemButtonsRow extends StatelessWidget {
  const InvoiceNewItemButtonsRow(
      {super.key,
      required this.onAddService,
      required this.onAddMedicine,
      required this.onAddAccessory});

  final VoidCallback onAddService;
  final VoidCallback onAddMedicine;
  final VoidCallback onAddAccessory;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextButton(
            height: 60.h,
            icon: Icons.medical_services_outlined,
            text: 'Add Service',
            onPressed: onAddService,
            textStyle: AppTextStyles.font16DarkGreyMedium
                .copyWith(color: Colors.white),
          ),
        ),
        horizontalSpace(20),
        Expanded(
          child: AppTextButton(
            height: 60.h,
            icon: Icons.medication_liquid_sharp,
            text: 'Add Medicine',
            onPressed: onAddMedicine,
            textStyle: AppTextStyles.font16DarkGreyMedium
                .copyWith(color: Colors.white),
          ),
        ),
        horizontalSpace(20),
        Expanded(
          child: AppTextButton(
            height: 60.h,
            icon: Icons.animation_outlined,
            text: 'Add Accessory',
            onPressed: onAddAccessory,
            textStyle: AppTextStyles.font16DarkGreyMedium
                .copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
