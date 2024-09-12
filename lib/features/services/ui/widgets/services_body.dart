import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/animated_loading_indicator.dart';
import 'package:el_sharq_clinic/core/widgets/app_grid_view.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';
import 'package:el_sharq_clinic/features/services/logic/cubit/services_cubit.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/service_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServicesBody extends StatelessWidget {
  const ServicesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionDetailsContainer(
      padding: EdgeInsets.symmetric(vertical: 25.h),
      color: AppColors.white,
      child: BlocBuilder<ServicesCubit, ServicesState>(
        buildWhen: (_, current) =>
            current is ServicesLoading ||
            current is ServicesSuccess ||
            current is ServicesSearchSuccess ||
            current is ServicesError,
        builder: (context, state) {
          if (state is ServicesSuccess) {
            return _buildSuccess(state.services, context);
          }
          if (state is ServicesSearchSuccess) {
            return _buildSuccess(state.services, context);
          }
          if (state is ServicesError) {
            return _buildError(state, context);
          }
          return _buildLoading();
        },
      ),
    );
  }

  Center _buildLoading() => const Center(child: AnimatedLoadingIndicator());

  Center _buildError(ServicesError state, BuildContext context) {
    return Center(
      child: Text(state.message,
          style: AppTextStyles.font24DarkGreyMedium(context)),
    );
  }

  Widget _buildSuccess(List<ServiceModel> services, BuildContext context) {
    if (services.isEmpty) {
      return Center(
          child: Text('There are no services yet',
              style: AppTextStyles.font24DarkGreyMedium(context)));
    }
    return AppGridView(
      itemCount: services.length,
      itemBuilder: (_, index) => ServiceItem(service: services[index]),
    );
  }
}
