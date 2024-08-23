import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/assets.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';
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
          ServiceModel(
            title: 'X-ray',
            price: 100,
            icon: Assets.assetsImagesPngHeartRate,
            description: 'X-ray of the head',
          ),
          ServiceModel(
            title: 'MRI',
            price: 200,
            icon: Assets.assetsImagesPngHospital,
            description: 'MRI of the head',
          ),
          ServiceModel(
            title: 'CT scan',
            price: 300,
            icon: Assets.assetsImagesPngPump,
            description: 'CT scan of the head',
          ),
          ServiceModel(
            title: 'Ultrasound',
            price: 400,
            icon: Assets.assetsImagesPngReport,
            description: 'Ultrasound of the head',
          ),
          ServiceModel(
            title: 'Blood test',
            price: 500,
            icon: Assets.assetsImagesPngDoubleMedicine,
            description: 'Blood test of the head',
          ),
        ],
      ),
    );
  }
}
