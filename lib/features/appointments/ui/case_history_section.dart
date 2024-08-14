import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/features/appointments/logic/cubit/case_history_cubit.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/case_history_body.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/case_history_side_sheet.dart';
import 'package:el_sharq_clinic/features/appointments/ui/widgets/case_history_bloc_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CaseHistorySection extends StatelessWidget {
  const CaseHistorySection({super.key, required this.authData});

  final AuthDataModel authData;

  @override
  Widget build(BuildContext context) {
    context.read<CaseHistoryCubit>().setAuthData(authData);
    return SectionContainer(
      title: 'Case History',
      actions: [
        AppTextButton(
          text: 'New Case',
          icon: Icons.book_outlined,
          onPressed: () =>
              showCaseHistoryideSheet(context, 'New Case', isNew: true),
          width: 275,
        )
      ],
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            const Expanded(child: CaseHistoryBody()),
            const CaseHistoryBlocListener(),
          ],
        ),
      ),
    );
  }
}
