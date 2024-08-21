import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/section_action_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/core/widgets/section_search_bar.dart';
import 'package:el_sharq_clinic/features/doctors/logic/cubit/doctors_cubit.dart';
import 'package:el_sharq_clinic/features/doctors/ui/widgets/doctors_body.dart';
import 'package:el_sharq_clinic/features/doctors/ui/widgets/doctors_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorsSection extends StatelessWidget {
  const DoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: 'Doctors',
      actions: [
        // Search bar
        SectionSearchBar(
          hintText: 'Search by doctor name',
          onChanged: (value) {},
        ),
        SectionActionButton(
          newText: 'New Doctor',
          onNewPressed: () => showDoctorSheet(context, 'New Doctor'),
          onDeletePressed: () => _onDeleteDoctors(context),
          valueNotifier: context.read<DoctorsCubit>().showDeleteButtonNotifier,
        ),
      ],
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            const Expanded(child: DoctorsBody()),
            // Add bloc listener here
          ],
        ),
      ),
    );
  }

  void _onDeleteDoctors(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AppAlertDialog(
        alertMessage: 'Are you sure you want to delete these owner profiles?\n'
            'This action cannot be undone.',
        onConfirm: () {
          context.read<DoctorsCubit>().onDeleteSelectedDoctors();
          context.pop();
        },
        onCancel: () {
          context.pop();
        },
      ),
    );
  }
}
