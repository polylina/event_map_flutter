import 'package:flutter/material.dart';

class ConditionBuilder extends StatelessWidget {
  final bool condition;
  final Widget Function(BuildContext context)? falsyBuilder;
  final Widget Function(BuildContext context) truthyBuilder;

  const ConditionBuilder({
    super.key,
    required this.condition,
    required this.truthyBuilder,
    this.falsyBuilder,
  });

  @override
  Widget build(BuildContext context) => condition
      ? truthyBuilder(context)
      : falsyBuilder != null
      ? falsyBuilder!(context)
      : Container();
}
