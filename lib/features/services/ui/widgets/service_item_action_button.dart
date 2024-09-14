import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';
import 'package:el_sharq_clinic/features/services/logic/cubit/services_cubit.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/services_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceItemActionButton extends StatelessWidget {
  const ServiceItemActionButton({
    super.key,
    required this.service,
  });

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            value: 'Edit',
            onTap: () => showServiceSheet(
              context,
              AppStrings.editService.tr(),
              service: service,
            ),
            child: Text(
              AppStrings.edit.tr(),
              style: AppTextStyles.font14DarkGreyMedium(context),
            ),
          ),
          PopupMenuItem(
            value: 'Delete',
            onTap: () {
              showDialog(
                context: ctx,
                builder: (_) => AppAlertDialog(
                  alertMessage: AppStrings.deleteServiceConfirmation.tr(),
                  onConfirm: () {
                    context.read<ServicesCubit>().deleteService(service);
                    ctx.pop();
                  },
                  onCancel: () {
                    ctx.pop();
                  },
                ),
              );
            },
            child: Text(
              AppStrings.delete.tr(),
              style: AppTextStyles.font14DarkGreyMedium(context),
            ),
          ),
        ];
      },
    );
  }
}
