import 'package:animate_do/animate_do.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/cases_last_week.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/low_stock_products.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/popular_items.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/today_sales_container.dart';
import 'package:el_sharq_clinic/features/dashboard/ui/widgets/today_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TodayOverview(state: state),
          ),
          verticalSpace(100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                FadeInLeft(
                  child: SizedBox(
                    width: 550.w,
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: CasesLastWeek(
                        weeklyCases: state.weeklyCasesMap,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                FadeInRight(
                  child: SizedBox(
                    width: 550.w,
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: TodaySalesContainer(
                        dataMap: state.todaySalesMap,
                        todayRevenue: state.todayRevenue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [
                FadeInLeft(
                  child: SizedBox(
                      width: 550.w,
                      child: AspectRatio(
                          aspectRatio: 2,
                          child: LowStockProducts(
                            items: state.lowStockProducts,
                          ))),
                ),
                const Spacer(),
                FadeInRight(
                  child: SizedBox(
                    width: 550.w,
                    child: AspectRatio(
                        aspectRatio: 2,
                        child: PopularItems(
                          items: state.popularItems,
                        )),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(25),
        ],
      ),
    );
  }
}
