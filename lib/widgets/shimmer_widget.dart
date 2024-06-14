import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget(
      {super.key,
      required this.height,
      required this.width,
      required this.shapeBorder});

  final double height;
  final double width;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular(this.height, this.width, {super.key})
      : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    super.key,
    required this.height,
    required this.width,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        decoration:
            ShapeDecoration(shape: shapeBorder, color: Colors.grey[400]!),
        height: height,
        width: width,
      ),
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!,
    );
  }
}
