import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/services_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesBody extends StatelessWidget {
  const ServicesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionDetailsContainer(
      padding: EdgeInsets.symmetric(vertical: 25.h),
      color: AppColors.white,
      child: const ServicesGridView(
        items: [
          'title 1',
          'title 2',
          'title 3',
          'title 4',
          'title 5',
          'title 6',
          'title 7',
          'title 8',
        ],
      ),
    );
  }
}
