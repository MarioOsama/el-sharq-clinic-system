import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:flutter/material.dart';

class OwnersRowActionButton extends StatelessWidget {
  const OwnersRowActionButton({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            value: 'Edit',
            onTap: () {},
            child: const Text(
              'Edit',
              style: AppTextStyles.font14DarkGreyMedium,
            ),
          ),
          PopupMenuItem(
            value: 'Add Pet',
            onTap: () {},
            child: const Text(
              'Add Pet',
              style: AppTextStyles.font14DarkGreyMedium,
            ),
          ),
          PopupMenuItem(
            value: 'Delete',
            onTap: () {
              showDialog(
                context: ctx,
                builder: (_) => AppAlertDialog(
                  alertMessage: 'Are you sure you want to delete this case?\n'
                      'This action cannot be undone.',
                  onConfirm: () {
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
