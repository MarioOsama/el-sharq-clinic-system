import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/theming/assets.dart';
import 'package:el_sharq_clinic/core/widgets/app_drop_down_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesIconDropDownButton extends StatelessWidget {
  const ServicesIconDropDownButton({
    super.key,
    required this.enabled,
  });

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Icon',
          style: AppTextStyles.font16DarkGreyMedium
              .copyWith(color: AppColors.darkGrey.withOpacity(0.5)),
        ),
        AppDropDownButton(
          enabled: enabled,
          height: 61.h,
          items: const [
            Assets.assetsImagesPngDoubleMedicine,
            Assets.assetsImagesPngHeartRate,
            Assets.assetsImagesPngHospital,
            Assets.assetsImagesPngMedecine,
            Assets.assetsImagesPngPump,
            Assets.assetsImagesPngReport,
          ],
          itemBuilder: (value) => DropdownMenuItem(
            value: value,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(value!),
            ),
          ),
          onChanged: (value) {},
        ),
      ],
    );
  }
}
