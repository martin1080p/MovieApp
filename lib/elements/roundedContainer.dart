import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
      Key key,
      @required this.child,
      this.margin,
      this.padding,
      this.width,
      this.borderRadius,
      this.alignment

    }) : super(key: key);
  
  final Widget child;
  final double width;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
              color: Theme.of(context).cardColor,
              width: 0),
          borderRadius: borderRadius == null ? BorderRadius.all(Radius.circular(8.0)) : borderRadius),
      child: child,
    );
  }
}