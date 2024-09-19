import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/highlights_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MobileTodayOverview extends StatelessWidget {
  const MobileTodayOverview({super.key, required this.state});

  final DashboardSuccess state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.todayOverview.tr(),
              style: AppTextStyles.font22DarkGreyMedium(context),
            ),
            IconButton(
              onPressed: () {
                _refreshData(context);
              },
              icon: const Icon(
                Icons.refresh_rounded,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
        verticalSpace(20),
        Center(
          child: TodayHighlightsWrap(
            cases: state.todayCasesCount,
            owners: state.todayOwnersCount,
            invoices: state.todayInvoicesCount,
            revenue: state.todayRevenue,
          ),
        ),
      ],
    );
  }

  void _refreshData(BuildContext context) {
    context.read<DashboardCubit>().refreshData();
  }
}
