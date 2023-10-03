import 'package:flutter/material.dart';

/// Wrapper for stateful functionality to provide onInit calls in stateles widget
class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;
  final Function? onDeactivate;
  final Function? onDispose;

  const StatefulWrapper(
      {required this.onInit,
      required this.child,
      this.onDeactivate,
      this.onDispose});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void deactivate() {
    if (widget.onDeactivate != null) widget.onDeactivate!();
    super.deactivate();
  }

  @override
  void dispose() {
    if (widget.onDispose != null) widget.onDispose!();
    super.dispose();
  }
}
