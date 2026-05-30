import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/consts.dart';

class NoteTextWidget extends StatelessWidget {
  const NoteTextWidget({
    super.key,
    this.isVisible = true,
    required this.text,
  });
  final bool isVisible;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: K.pvmH),
        padding: EdgeInsets.all(8.0.r),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .errorContainer
              .withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(K.rm),
        ),
        child: Text(
          text,
          overflow: TextOverflow.clip,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontSize: 15.0.sp),
        ),
      ),
    );
  }
}
