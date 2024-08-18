import 'package:flutter/material.dart';
import 'package:side_sheet/side_sheet.dart';

Future<void> showCustomSideSheet(
    {required BuildContext context, required Widget child}) async {
  await SideSheet.right(
    context: context,
    width: MediaQuery.of(context).size.width * 0.45,
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 35),
        child: child,
      ),
    ),
  );
}
