import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';
import 'package:el_sharq_clinic/features/services/ui/widgets/services_side_sheet.dart';
import 'package:flutter/material.dart';

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
              'Edit Service',
              service: service,
            ),
            child: const Text(
              'Edit',
              style: AppTextStyles.font14DarkGreyMedium,
            ),
          ),
          PopupMenuItem(
            value: 'Delete',
            onTap: () {
              showDialog(
                context: ctx,
                builder: (_) => AppAlertDialog(
                  alertMessage:
                      'Are you sure you want to delete this service?\n'
                      'This action cannot be undone.',
                  onConfirm: () {
                    //TODO: Implement delete logic
                    ctx.pop();
                  },
                  onCancel: () {
                    ctx.pop();
                  },
                ),
              );
            },
            child: const Text(
              'Delete',
              style: AppTextStyles.font14DarkGreyMedium,
            ),
          ),
        ];
      },
    );
  }
}
