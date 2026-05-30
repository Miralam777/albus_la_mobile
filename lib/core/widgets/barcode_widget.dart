import 'package:barcode/barcode.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BarcodeWidget extends StatelessWidget {
  const BarcodeWidget({
    super.key,
    required this.barcodeData,
    this.height = 70,
    this.width = 150,
    this.barcodeColor = Colors.black,
    this.bgColor,
    this.padding,
  });

  final String? barcodeData;

  /// height default 70.0.w
  final double height;

  /// width default 150.0.w
  final double width;

  /// barcodeColor default Colors.black
  final Color barcodeColor;

  /// bgColor default secondaryContainer
  final Color? bgColor;

  /// padding default 150.0.w
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    try {
      final barcodeSvg = Barcode.itf().toSvg(
        barcodeData.toString(),
        height: height.h,
        width: width.w,
        color: barcodeColor.value,
      );

      return Center(
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bgColor ?? Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(K.rm),
          ),
          child: SvgPicture.string(barcodeSvg),
        ),
      );
    } catch (_) {
      return const Text('Barcode Error');
    }
  }
}
