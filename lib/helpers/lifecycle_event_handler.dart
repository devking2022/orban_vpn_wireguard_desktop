import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;
  final AsyncCallback pausedCallBack;
  final AsyncCallback inactiveCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
    required this.pausedCallBack,
    required this.suspendingCallBack,
    required this.inactiveCallBack,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state.name);
    switch (state) {
      case AppLifecycleState.resumed:
        resumeCallBack();
        break;
      case AppLifecycleState.paused:
        pausedCallBack();
        break;
      case AppLifecycleState.inactive:
        inactiveCallBack();
        break;
      case AppLifecycleState.detached:
        suspendingCallBack();
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }
}
