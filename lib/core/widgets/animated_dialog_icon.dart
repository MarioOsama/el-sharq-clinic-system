import 'package:el_sharq_clinic/core/widgets/app_dialog.dart';
import 'package:flutter/material.dart';

class AnimatedDialogIcon extends StatefulWidget {
  const AnimatedDialogIcon({super.key, required this.dialogType});

  final DialogType dialogType;

  @override
  State<AnimatedDialogIcon> createState() => _AnimatedDialogIconState();
}

class _AnimatedDialogIconState extends State<AnimatedDialogIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(
        widget.dialogType == DialogType.alert
            ? Icons.warning
            : widget.dialogType == DialogType.success
                ? Icons.check_circle
                : Icons.error,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
