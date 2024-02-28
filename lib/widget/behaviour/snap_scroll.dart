import 'package:flutter/foundation.dart' show PlatformDispatcher;
import 'package:flutter/material.dart';

/// This scroll physic have snapping behavior. You can use it in listview or
/// another list widget as long as you can set the scroll physic via constructor
/// of the widget. This code is inspired by another lib.
class SnappScrollPhysic extends ScrollPhysics {
  final double itemHeight;

  final double targetPixelLimit;

  const SnappScrollPhysic({
    super.parent,
    required this.itemHeight,
    this.targetPixelLimit = 3.0,
  });

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnappScrollPhysic(
      parent: buildParent(ancestor),
      itemHeight: itemHeight,
    );
  }

  /// This function is contain a logic & a key how we can enable snap behavior
  /// on the list by reading visible item position when the list got scrolled.
  /// if velocity is less than -tolerance velocity, we need to decrease the item
  /// position so it's gonna force the list to scrolled up to the another item
  /// on the list. else if the velocity is bigger than tolerance velocity we
  /// need to increase itemPosition so it will give scroll down effect to the
  /// list.
  double _getTargetPixels(
    ScrollPosition position,
    double velocity,
    double toleranceVelocity,
  ) {
    double visibleItemPosition = position.pixels / itemHeight;
    if (velocity < -toleranceVelocity) {
      visibleItemPosition -= targetPixelLimit;
    } else if (velocity > toleranceVelocity) {
      visibleItemPosition += targetPixelLimit;
    }

    final pixels = visibleItemPosition.roundToDouble() * itemHeight;
    return pixels;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final tolerance = toleranceFor(FixedScrollMetrics(
      minScrollExtent: null,
      maxScrollExtent: null,
      pixels: null,
      viewportDimension: null,
      axisDirection: AxisDirection.down,
      devicePixelRatio:
          PlatformDispatcher.instance.implicitView?.devicePixelRatio ?? 0,
    ));
    final target = _getTargetPixels(
      position as ScrollPosition,
      velocity,
      tolerance.velocity,
    );

    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }

    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
