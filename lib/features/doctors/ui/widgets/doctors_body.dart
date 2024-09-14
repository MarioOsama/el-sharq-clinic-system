import 'package:easy_localization/easy_localization.dart';
import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/helpers/strings.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table_data_source.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/doctors/logic/cubit/doctors_cubit.dart';
import 'package:el_sharq_clinic/features/doctors/ui/widgets/doctors_row_action_button.dart';
import 'package:el_sharq_clinic/features/doctors/ui/widgets/doctors_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorsBody extends StatefulWidget {
  const DoctorsBody({super.key});

  @override
  State<DoctorsBody> createState() => _DoctorsBodyState();
}

class _DoctorsBodyState extends State<DoctorsBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorsCubit, DoctorsState>(
      buildWhen: (previous, current) =>
          current is DoctorsSuccess ||
          current is DoctorsError ||
          current is DoctorsLoading,
      builder: (context, state) {
        return SectionDetailsContainer(
          color: state is DoctorsSuccess
              ? AppColors.darkGrey.withOpacity(0.75)
              : AppColors.white,
          child: _buildChild(context, state),
        );
      },
    );
  }

  Widget _buildChild(BuildContext context, DoctorsState state) {
    if (state is DoctorsSuccess) {
      return _buildSuccess(context, state);
    }
    if (state is DoctorsError) {
      return Center(
        child: Text(state.message),
      );
    }
    return const Center(child: FadedAnimatedLoadingIcon());
  }

  CustomTable _buildSuccess(BuildContext context, DoctorsState state) {
    final DoctorsCubit doctorsCubit = context.read<DoctorsCubit>();
    return CustomTable(
      onPageChanged: (firstIndex) {},
      fields: AppConstant.doctorsTableHeaders,
      dataSource: CustomTableDataSource(
        columnsCount: AppConstant.doctorsTableHeaders.length,
        data: _getRows(state),
        actionBuilder: (id) => DoctorsRowActionButton(
          id: id,
        ),
        tappableCellIndex: 0,
        onSelectionChanged: (index, selected) => setState(() {
          doctorsCubit.onMultiSelection(index, selected);
        }),
        onTappableCellTap: (id) => showDoctorSheet(
          context,
          AppStrings.doctorDetails.tr(),
          editable: false,
          doctor: doctorsCubit.getDoctorById(id),
        ),
        selectedRows: doctorsCubit.selectedRows,
      ),
    );
  }

  List<List<String>> _getRows(DoctorsState state) {
    return (state as DoctorsSuccess).doctors.map((doctor) {
      return doctor!.toList();
    }).toList();
  }
}
