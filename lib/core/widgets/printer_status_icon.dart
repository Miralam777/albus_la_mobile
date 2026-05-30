import 'package:flutter/material.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrinterStatusIcon extends StatelessWidget {
  const PrinterStatusIcon({super.key, required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: null,
      iconSize: 30.0.r,
      isSelected: true,
      disabledColor: isConnected ? Theme.of(context).iconTheme.color : null,
      icon: isConnected
          ? Icon(I.printer)
          : Stack(
              children: [
                Icon(I.printer),
                Positioned(
                  bottom: 1.0.h,
                  right: 1.0.h,
                  child: Icon(I.cancel, size: 17.0.r, color: Colors.red),
                ),
              ],
            ),
    );
  }
}
