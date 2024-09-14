import 'dart:async';
import 'package:el_sharq_clinic/core/helpers/spacing.dart';
import 'package:el_sharq_clinic/core/theming/app_colors.dart';
import 'package:el_sharq_clinic/core/theming/app_text_styles.dart';
import 'package:el_sharq_clinic/core/widgets/faded_animated_loading_icon.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityMonitor extends StatefulWidget {
  final Widget child;

  const ConnectivityMonitor({super.key, required this.child});

  @override
  State<ConnectivityMonitor> createState() => _ConnectivityMonitorState();
}

class _ConnectivityMonitorState extends State<ConnectivityMonitor> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isConnected = true; // Assuming initially connected
  late Widget displayedWidget;

  @override
  void initState() {
    super.initState();
    // Start listening to connectivity changes
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);

    displayedWidget = widget.child;
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) async {
    bool previousConnectionStatus = _isConnected;

    if (result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.mobile)) {
      _isConnected = true;
    } else {
      _isConnected = false;
    }

    // If connection status has changed, take the appropriate action
    if (previousConnectionStatus != _isConnected) {
      _handleConnectionChange();
    }
  }

  void _handleConnectionChange() {
    if (_isConnected) {
      // Action when internet is restored
      displayedWidget = widget.child;
      setState(() {});
    } else {
      // Action when internet is lost
      displayedWidget = _noConnectionWidget();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return displayedWidget;
  }

  Widget _noConnectionWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FadedAnimatedLoadingIcon(
              iconData: Icons.wifi_off,
              color: AppColors.darkGrey,
            ),
            verticalSpace(100),
            Text(
              'No Internet Connection',
              style: AppTextStyles.font32DarkGreyMedium(context).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
