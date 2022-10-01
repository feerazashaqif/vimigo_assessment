// ignore_for_file: unused_field

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vimigo_assessment/models/goal.dart';

class GoalPath extends CustomPainter {
  GoalPath(this.progress,
      {required this.color, required this.level, required this.opacity});
  double progress;
  final Color color;
  final int level;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    //Define properties for path background
    var paintInit = Paint()
      ..color = Color.fromARGB((255 * opacity).toInt(), 216, 216, 216)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    //Define properties for path foreground
    var paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    //Draw path background
    canvas.drawPath(initialPath(size), paintInit);
    canvas.drawPath(createGoalPath(size), paintInit);

    //Draw initial path foreground
    canvas.drawPath(initialPath(size), paint);

    //Define progressed path
    var path = createGoalPath(size);
    debugPrint(progress.toString());
    final animatedPath =
        createAnimatedPath(path, progress / (level - 1));

    canvas.drawPath(animatedPath, paint);
  }

  @override
  bool shouldRepaint(covariant GoalPath oldDelegate) => true;

//Path before level 1
  Path initialPath(Size size) {
    Path path;
    double sh = size.height;
    double sw = size.width;
    double cornerSide = 32;
    double horizontalEnd = 64;
    double boxH = 40;
    path = Path();
    //draw path from start to level 1
    return path
      ..moveTo(sw / 2, sh)
      ..lineTo(sw / 2, sh - 16)
      ..quadraticBezierTo(sw / 2, sh - 16 - cornerSide, sw / 2 + cornerSide,
          sh - 16 - cornerSide)
      ..lineTo(sw - horizontalEnd - cornerSide, sh - 16 - cornerSide)
      ..quadraticBezierTo(sw - horizontalEnd, sh - 16 - cornerSide,
          sw - horizontalEnd, sh - 16 - 2 * cornerSide)
      ..lineTo(sw - horizontalEnd, sh - 16 - 2 * cornerSide - boxH);
  }

//Draw dynamic path according number of level
  Path createGoalPath(Size size) {
    Path path;
    double sh = size.height;
    double sw = size.width;
    double cornerSide = 32;
    double horizontalEnd = 64;
    double boxH = 40;
    double currHeight = -16;
    path = Path();
    path.moveTo(sw - horizontalEnd, sh - 16 - 2 * cornerSide - boxH);
    currHeight = sh - 16 - 2 * cornerSide - boxH;
    for (int x = 2; x <= Goal.goals.length; x++) {
      if (x.isEven) {
        //Draw left-sided path
        currHeight = currHeight - cornerSide - boxH;
        path
          ..lineTo(sw - horizontalEnd, currHeight + cornerSide)
          ..quadraticBezierTo(sw - horizontalEnd, currHeight,
              sw - horizontalEnd - cornerSide, currHeight)
          ..lineTo(horizontalEnd + cornerSide, currHeight)
          ..quadraticBezierTo(horizontalEnd, currHeight, horizontalEnd,
              currHeight - cornerSide);
        currHeight = currHeight - cornerSide - boxH;
        path.lineTo(horizontalEnd, currHeight);
      } else {
        //Draw right-sided path
        currHeight = currHeight - boxH;
        path.lineTo(horizontalEnd, currHeight);
        currHeight = currHeight - cornerSide;
        path
          ..quadraticBezierTo(
              horizontalEnd, currHeight, horizontalEnd + cornerSide, currHeight)
          ..lineTo(sw - horizontalEnd - cornerSide, currHeight)
          ..quadraticBezierTo(sw - horizontalEnd, currHeight,
              sw - horizontalEnd, currHeight - cornerSide);
        currHeight = currHeight - cornerSide - boxH;
        path.lineTo(sw - horizontalEnd, currHeight);
      }
    }
    return path;
  }

//Draw animated path which will be animated when selecting level
  Path createAnimatedPath(
    Path originalPath,
    double animationPercent,
  ) {
    final totalLength = originalPath
        .computeMetrics()
        .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

    final currentLength = totalLength * animationPercent;

    return extractPathUntilLength(originalPath, currentLength);
  }

  Path extractPathUntilLength(
    Path originalPath,
    double length,
  ) {
    var currentLength = 0.0;

    final path = Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }
}
