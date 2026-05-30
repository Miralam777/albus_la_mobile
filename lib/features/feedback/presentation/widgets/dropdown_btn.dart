import 'package:albus_la_mobile/constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropdownBtnWidget extends StatelessWidget {
  const DropdownBtnWidget({
    super.key,
    required this.dropdownVal,
    required this.dropdownsItems,
    required this.onDropdownchange,
  });

  final String dropdownVal;
  final List<String> dropdownsItems;
  final Function(String? val) onDropdownchange;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(K.rm),
      child: DropdownButton<String>(
        value: dropdownVal,
        isExpanded: true,
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(K.rl),
        underline: const SizedBox.shrink(),
        padding: EdgeInsets.symmetric(vertical: 7.5.h, horizontal: 10.0.w),
        items: dropdownsItems.map<DropdownMenuItem<String>>((value) {
          final bool isEnable = value != dropdownVal;
          return DropdownMenuItem<String>(
            value: value,
            enabled: isEnable,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 2.5.h),
              decoration: BoxDecoration(
                color: isEnable
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(K.rs),
              ),
              child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ),
          );
        }).toList(),
        onChanged: onDropdownchange,
      ),
    );
  }
}
