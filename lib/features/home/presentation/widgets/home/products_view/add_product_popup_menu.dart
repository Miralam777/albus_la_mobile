import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum _Menu { license, product }

class AddProductPopupMenu extends StatelessWidget {
  const AddProductPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_Menu>(
      popUpAnimationStyle: AnimationStyle(duration: const Duration(seconds: 1)),
      icon: Icon(I.add),
      onSelected: (_Menu item) {
        if (item == _Menu.product) {
          context.push(Routes.addUpdateProductPage);
        } else if (item == _Menu.license) {
          context.push(Routes.addUpdateLicensePage);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<_Menu>>[
        _buildItem(
          value: _Menu.product,
          icon: I.category,
          // TODO: text
          title: 'Product hinzufügen',
        ),
        const PopupMenuDivider(),
        _buildItem(
          value: _Menu.license,
          icon: I.license,
          // TODO: text
          title: 'Lizenz hinzufügen',
        ),
      ],
    );
  }

  PopupMenuItem<_Menu> _buildItem({
    required _Menu value,
    required IconData icon,
    required String title,
  }) {
    return PopupMenuItem<_Menu>(
      value: value,
      child: ListTile(
        leading: Padding(
          padding: EdgeInsets.only(left: K.pm),
          child: Icon(icon),
        ),
        title: Text(title),
      ),
    );
  }
}
