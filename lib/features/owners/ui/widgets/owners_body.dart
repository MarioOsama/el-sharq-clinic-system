import 'package:el_sharq_clinic/core/helpers/constants.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/widgets/animated_loading_indicator.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table.dart';
import 'package:el_sharq_clinic/core/widgets/custom_table_data_source.dart';
import 'package:el_sharq_clinic/core/widgets/section_details_container.dart';
import 'package:el_sharq_clinic/features/owners/logic/cubit/owners_cubit.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/owners_row_action_button.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/owners_side_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OwnersBody extends StatefulWidget {
  const OwnersBody({super.key});

  @override
  State<OwnersBody> createState() => _OwnersBodyState();
}

class _OwnersBodyState extends State<OwnersBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnersCubit, OwnersState>(
      buildWhen: (previous, current) =>
          current is OwnersSuccess ||
          current is OwnersError ||
          current is OwnersLoading,
      builder: (context, state) {
        return SectionDetailsContainer(
          color: state is OwnersSuccess
              ? AppColors.darkGrey.withOpacity(0.75)
              : AppColors.white,
          child: _buildChild(context, state),
        );
      },
    );
  }

  Widget _buildChild(BuildContext context, OwnersState state) {
    if (state is OwnersSuccess) {
      return _buildSuccess(context, state);
    }
    if (state is OwnersError) {
      return Center(
        child: Text(state.errorMessage),
      );
    }
    return const Center(child: AnimatedLoadingIndicator());
  }

  CustomTable _buildSuccess(BuildContext context, OwnersState state) {
    final ownersCubit = context.read<OwnersCubit>();
    return CustomTable(
      onPageChanged: (firstIndex) {
        ownersCubit.getNextPage(firstIndex);
      },
      fields: AppConstant.ownersTableHeaders,
      dataSource: CustomTableDataSource(
        columnsCount: AppConstant.ownersTableHeaders.length,
        data: _getRows(state),
        actionBuilder: (id) => OwnersRowActionButton(
          id: id,
        ),
        tappableCellIndex: 0,
        onSelectionChanged: (index, selected) {
          setState(() {
            ownersCubit.onMultiSelection(index, selected);
          });
        },
        onTappableCellTap: (id) => showOwnerSheet(context, 'Owner Details',
            editable: false, ownerModel: ownersCubit.getOwnerById(id)),
        selectedRows: ownersCubit.selectedRows,
      ),
    );
  }

  List<List<String>> _getRows(OwnersState state) {
    return (state as OwnersSuccess).owners.map((owner) {
      return owner!.toList();
    }).toList();
  }
}
