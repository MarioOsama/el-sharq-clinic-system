import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/features/doctors/logic/cubit/doctors_cubit.dart';
import 'package:el_sharq_clinic/features/doctors/ui/widgets/doctors_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorsRowActionButton extends StatelessWidget {
  const DoctorsRowActionButton({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
            value: 'Edit',
            onTap: () {
              showDoctorSheet(
                context,
                'Edit Doctor',
                editable: true,
                doctor: context.read<DoctorsCubit>().getDoctorById(id),
              );
            },
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
                      'Are you sure you want to delete this doctor profile?\n'
                      'This action cannot be undone.',
                  onConfirm: () {
                    context.read<DoctorsCubit>().onDeleteDoctor(id);
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
