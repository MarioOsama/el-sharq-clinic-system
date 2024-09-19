import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/routing/app_routes.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarUserInfo extends StatelessWidget {
  const AppBarUserInfo({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    const double size = 20;

    return Row(
      children: [
        CircleAvatar(
          radius: size.r,
          backgroundColor: AppColors.grey,
          child: const Icon(Icons.person_outline),
        ),
        horizontalSpace(15),
        Text(
          userName,
          style: _getTextStyle(context),
        ),
        horizontalSpace(10),
        IconButton(
          icon: locale == const Locale('en')
              ? Icon(
                  Icons.logout,
                  size: size.sp,
                )
              : RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.logout,
                    size: size.sp,
                  ),
                ),
          onPressed: () {
            context.pushReplacementNamed(AppRoutes.auth);
          },
        ),
      ],
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    const String flavor = appFlavor ?? 'Mobile';
    return flavor == 'Mobile'
        ? AppTextStyles.font14DarkGreyMedium(context).copyWith(
            fontWeight: FontWeight.bold,
          )
        : AppTextStyles.font16DarkGreyMedium(context).copyWith(
            fontWeight: FontWeight.bold,
          );
  }
}
