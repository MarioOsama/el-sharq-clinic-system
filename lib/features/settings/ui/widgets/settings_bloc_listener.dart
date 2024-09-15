import 'package:el_sharq_clinic/features/settings/logic/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBlocListener extends StatelessWidget {
  const SettingsBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) =>
          current is SettingsUpdated ||
          current is SettingsUpdatingError ||
          current is SettingsUpdating,
      listener: (context, state) {
        state.takeAction(context);
      },
      child: const SizedBox.shrink(),
    );
  }
}
