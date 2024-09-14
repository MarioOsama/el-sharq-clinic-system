import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/widgets/section_action_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/core/widgets/section_search_bar.dart';
import 'package:el_sharq_clinic/features/services/logic/cubit/services_cubit.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/service_bloc_listener.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/services_body.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/services_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: AppStrings.services.tr(),
      actions: [
        // Search bar
        SectionSearchBar(
          hintText: AppStrings.servicesSearchText.tr(),
          onChanged: (value) =>
              context.read<ServicesCubit>().onSearchServices(value),
        ),
        SectionActionButton(
          newText: AppStrings.newService.tr(),
          onNewPressed: () {
            showServiceSheet(context, AppStrings.newService.tr());
          },
        ),
      ],
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            const Expanded(child: ServicesBody()),
            const ServicesBlocListener(),
          ],
        ),
      ),
    );
  }
}
