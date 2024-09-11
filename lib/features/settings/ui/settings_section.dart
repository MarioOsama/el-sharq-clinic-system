import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/widgets/app_text_button.dart';
import 'package:el_sharq_clinic/core/widgets/section_container.dart';
import 'package:el_sharq_clinic/features/settings/logic/cubit/settings_cubit.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/settings_bloc_listener.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/settings_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> saveButtonState =
        context.read<SettingsCubit>().saveButtonState;

    return SectionContainer(
      title: 'Settings',
      actions: [
        ListenableBuilder(
          listenable: saveButtonState,
          builder: (ctx, child) => AppTextButton(
            text: 'Save',
            width: 200.w,
            height: 55.h,
            icon: Icons.save,
            onPressed: () => context
                .read<SettingsCubit>()
                .onSavePreferences(context.read<MainCubit>()),
            enabled: saveButtonState.value,
          ),
        )
      ],
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(50),
            const Expanded(child: SettingsBody()),
            const SettingsBlocListener(),
          ],
        ),
      ),
    );
  }
}
