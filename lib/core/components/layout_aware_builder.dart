import 'package:flutter/material.dart';

class LayoutAwareBuilder<T> extends StatefulWidget {
  final T portraitLayout;
  final T? landscapeLayout;
  final Widget Function(BuildContext context, T layout) builder;

  const LayoutAwareBuilder({
    super.key,
    required this.portraitLayout,
    required this.builder,
    this.landscapeLayout,
  });

  @override
  State<LayoutAwareBuilder<T>> createState() => _LayoutAwareBuilderState<T>();
}

class _LayoutAwareBuilderState<T> extends State<LayoutAwareBuilder<T>> {
  T? layout;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;
        layout = isPortrait || widget.landscapeLayout == null
            ? widget.portraitLayout
            : widget.landscapeLayout;
        return widget.builder(context, layout as T);
      },
    );
  }
}
