import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/features/owners/ui/widgets/side_sheet_pet_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideSheetPetsColumn extends StatelessWidget {
  const SideSheetPetsColumn(
      {super.key,
      required this.editable,
      required this.petsNumberNotifier,
      required this.petFormsKeys,
      required this.onDecrementPets});

  final bool editable;
  final ValueNotifier<int> petsNumberNotifier;
  final List<GlobalKey<FormState>> petFormsKeys;
  final void Function(int index) onDecrementPets;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: petsNumberNotifier,
      builder: (ctx, state) {
        return Column(
          children: _getPets(petsNumberNotifier.value),
        );
      },
    );
  }

  List<Widget> _getPets(int numberOfPets) {
    return List.generate(
      numberOfPets,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Stack(
          children: [
            SideSheetPetContainer(
              petFormKey: petFormsKeys[index],
              index: index + 1,
              editable: editable,
            ),
            if (index != 0) _buildRemoveButton(index),
          ],
        ),
      ),
    );
  }

  Positioned _buildRemoveButton(int index) {
    return Positioned(
      top: 30.h,
      right: 0,
      child: IconButton(
          hoverColor: Colors.transparent,
          icon: const Icon(
            Icons.cancel,
            color: AppColors.red,
            size: 30,
          ),
          onPressed: () {
            onDecrementPets(index);
          }),
    );
  }
}
