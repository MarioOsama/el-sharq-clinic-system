import 'package:animate_do/animate_do.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/current_week_cases.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/low_stock_products.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/popular_items.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/today_overview_mobile.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/today_sales_container_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MobileDashboardBody extends StatelessWidget {
  const MobileDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionDetailsContainer(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return _buildChild(state, context);
        },
      ),
    );
  }

  Widget _buildChild(DashboardState state, BuildContext context) {
    if (state is DashboardSuccess) {
      return _buildSuccess(state);
    } else if (state is DashboardError) {
      return _buildError(state.message, context);
    }

    return _buildLoading();
  }

  Center _buildError(String message, BuildContext context) {
    return Center(
      child: Text(message, style: AppTextStyles.font20DarkGreyMedium(context)),
    );
  }

  Center _buildLoading() {
    return const Center(
      child: FadedAnimatedLoadingIcon(),
    );
  }

  SingleChildScrollView _buildSuccess(DashboardSuccess state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MobileTodayOverview(state: state),
          ),
          verticalSpace(50),
          FadeInLeft(
            child: SizedBox(
              width: 380.w,
              child: AspectRatio(
                aspectRatio: 1.7,
                child: CurrentWeekCases(
                  weeklyCases: state.weeklyCasesMap,
                  barWidth: 25,
                ),
              ),
            ),
          ),
          verticalSpace(50),
          FadeInRight(
            child: SizedBox(
              width: 380.w,
              child: AspectRatio(
                aspectRatio: 0.85,
                child: MobileTodaySalesContainer(
                  dataMap: state.todaySalesMap,
                  todayRevenue: state.todayRevenue,
                ),
              ),
            ),
          ),
          verticalSpace(50),
          FadeInLeft(
            child: SizedBox(
                width: 380.w,
                child: AspectRatio(
                    aspectRatio: 1,
                    child: LowStockProducts(
                      items: state.lowStockProducts,
                      aspectRatio: 1.25,
                    ))),
          ),
          verticalSpace(50),
          FadeInRight(
            child: SizedBox(
              width: 380.w,
              child: AspectRatio(
                  aspectRatio: 1,
                  child: PopularItems(
                    items: state.popularItems,
                    aspectRatio: 1.25,
                  )),
            ),
          ),
          verticalSpace(25),
        ],
      ),
    );
  }
}
