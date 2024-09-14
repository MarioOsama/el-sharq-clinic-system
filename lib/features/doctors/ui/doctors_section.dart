import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/widgets/app_alert_dialog.dart';
import 'package:el_sharq_clinic/core/widgets/section_action_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/core/widgets/section_search_bar.dart';
import 'package:el_sharq_clinic/features/doctors/logic/cubit/doctors_cubit.dart';
import 'package:el_sharq_clinic/features/doctors/ui/widgets/doctors_bloc_listener.dart';
import 'package:el_sharq_clinic/features/doctors/ui/widgets/doctors_body.dart';
import 'package:el_sharq_clinic/features/doctors/ui/widgets/doctors_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorsSection extends StatelessWidget {
  const DoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: AppStrings.doctors.tr(),
      actions: [
        // Search bar
        SectionSearchBar(
          hintText: AppStrings.doctorsSearchText.tr(),
          onChanged: (value) {
            context.read<DoctorsCubit>().onSearch(value);
          },
        ),
        SectionActionButton(
          newText: AppStrings.newDoctor.tr(),
          onNewPressed: () =>
              showDoctorSheet(context, AppStrings.newDoctor.tr()),
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
            const DoctorsBlocListener(),
          ],
        ),
      ),
    );
  }

  void _onDeleteDoctors(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AppAlertDialog(
        alertMessage: AppStrings.deleteDoctorConfirmationMultiple.tr(),
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
