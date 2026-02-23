import 'package:flutter/material.dart';

typedef OnDrag = bool Function(double offset, double viewportDimension);

class RefreshScrollPhysics extends ClampingScrollPhysics {
  const RefreshScrollPhysics({
    super.parent,
    required this.onDrag,
  });

  final OnDrag onDrag;

  @override
  RefreshScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return RefreshScrollPhysics(
      parent: buildParent(ancestor),
      onDrag: onDrag,
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value > 0.0 && onDrag(-value, position.viewportDimension)) {
      return value - position.minScrollExtent;
    }
    return super.applyBoundaryConditions(position, value);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (offset < 0.0 && onDrag(offset, position.viewportDimension)) {
      return 0.0;
    }
    return parent?.applyPhysicsToUserOffset(position, offset) ?? offset;
  }
}
