import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeLineItem extends StatelessWidget {
  const TimeLineItem({
    super.key,
    required this.time,
    required this.isReversed,
  });

  final String time;
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    return isReversed
        ? _ReversedItem(
            time: time,
          )
        : _NormalItem(
            time: time,
          );
  }
}

class _NormalItem extends StatelessWidget {
  const _NormalItem({
    super.key,
    required this.time,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: double.parse(time.split(':').join('.')) /
          24 *
          MediaQuery.of(context).size.width *
          70 /
          100,
      top: 20,
      child: Column(
        children: [
          _PannerContainer(
            child: Text(time, style: AppTextStyles.font16DarkGreyMedium),
          ),
          const _StickContainer(),
        ],
      ),
    );
  }
}

class _ReversedItem extends StatelessWidget {
  const _ReversedItem({
    super.key,
    required this.time,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: double.parse(time.split(':').join('.')) /
          24 *
          MediaQuery.of(context).size.width *
          70 /
          100,
      bottom: 20,
      child: Column(
        children: [
          const _ReversedStickContainer(),
          _PannerContainer(
            child: Text(time, style: AppTextStyles.font16DarkGreyMedium),
          ),
        ],
      ),
    );
  }
}

class _StickContainer extends StatelessWidget {
  const _StickContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 28.h,
          width: 3,
          color: AppColors.darkGrey,
        ),
        const CircleAvatar(
          radius: 8,
          backgroundColor: AppColors.darkGrey,
        )
      ],
    );
  }
}

class _ReversedStickContainer extends StatelessWidget {
  const _ReversedStickContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 8,
          backgroundColor: AppColors.darkGrey,
        ),
        Container(
          height: 28.h,
          width: 3,
          color: AppColors.darkGrey,
        ),
      ],
    );
  }
}

class _PannerContainer extends StatelessWidget {
  const _PannerContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 40,
      alignment: Alignment.center,
      decoration: _buildContainerDecoration(),
      child: child,
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: AppColors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.25),
            blurRadius: 5,
            spreadRadius: 3,
            offset: const Offset(2, 2),
          ),
        ]);
  }
}
