import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/time_line_item.dart';
import 'package:flutter/material.dart';

class CustomTimeLine extends StatelessWidget {
  const CustomTimeLine({
    super.key,
    required this.timesList,
  });

  final List<String> timesList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 5,
          color: AppColors.darkGrey,
        ),
        const Positioned(
          left: 0,
          child: CircleAvatar(
            radius: 5,
            backgroundColor: AppColors.darkGrey,
          ),
        ),
        const Positioned(
          right: 0,
          child: CircleAvatar(
            radius: 5,
            backgroundColor: AppColors.darkGrey,
          ),
        ),
        ..._getTimeLineItemsList,
      ],
    );
  }

  List<TimeLineItem> get _getTimeLineItemsList {
    return List.generate(timesList.length, (index) {
      return TimeLineItem(
        time: timesList[index],
        isReversed: index.isEven,
      );
    });
  }
}
