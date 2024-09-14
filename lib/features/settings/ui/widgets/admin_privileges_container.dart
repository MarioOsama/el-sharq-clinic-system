import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/features/settings/logic/cubit/settings_cubit.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/action_list_tile.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/add_user_account_dialog.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/change_clinic_name_dialog.dart';
import 'package:el_sharq_clinic/features/settings/ui/widgets/users_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminPrivilegesContainer extends StatelessWidget {
  const AdminPrivilegesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final authData = context.watch<SettingsCubit>().newAuthData!;

    return Column(
      children: [
        verticalSpace(20.h),
        ActionListTile(
          title: AppStrings.changeClinicName.tr(),
          onTap: () => showClinicNameDialog(context, authData.clinicName),
          iconData: Icons.edit,
        ),
        verticalSpace(20.h),
        ActionListTile(
          title: AppStrings.addUserAccount.tr(),
          onTap: () => showAddUserAccountDialog(context),
          iconData: Icons.person_add,
        ),
        verticalSpace(20.h),
        const UsersExpansionTile(),
      ],
    );
  }

  void showClinicNameDialog(BuildContext context, String clinicName) {
    showDialog(
      context: context,
      builder: (_) => ChangeClinicNameDialog(
        clinicName: clinicName,
        onNameChanged: context.read<SettingsCubit>().onClinicNameChanged,
      ),
    );
  }

  void showAddUserAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AddUserAccountDialog(
        onAccountAdded: context.read<SettingsCubit>().onAccountAdded,
      ),
    );
  }
}
