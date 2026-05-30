import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO
class PrimaryAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar2({
    super.key,
    required this.title,
    this.titleWidget,
    this.actions,
  });

  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      titleTextStyle: Theme.of(context)
          .appBarTheme
          .titleTextStyle
          ?.copyWith(color: Colors.white),
      title: titleWidget ?? Text(title),
      actions: actions,
    );
  }
}

// todo
class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    super.key,
    this.notificationPredicate = true,
    this.bgColor,
    required this.title,
    this.leading,
    this.actions,
  });

  /// by default is true
  final bool notificationPredicate;
  final Color? bgColor;
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      title: Text(title),
      leading: leading,
      notificationPredicate: (ScrollNotification value) =>
          notificationPredicate,
      actions: actions,
      flexibleSpace: const AppBarBottomDivider(),
    );
  }
}

class AppBarBottomDivider extends StatelessWidget {
  const AppBarBottomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.secondaryContainer,
            // width: 0.3.r,
            width: 0.7.r,
          ),
        ),
      ),
    );
  }
}
