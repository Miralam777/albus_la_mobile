import 'package:albus_la_mobile/gen/assets.gen.dart';

import '/constants/consts.dart';
import '/core/widgets/svg_un_draw_image.dart';
import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key, this.message});

  /// default text 'Die Liste ist Derzeit leer.'
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(K.pm / 2),
          margin: EdgeInsets.symmetric(horizontal: K.pm),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(K.rl),
          ),
          child: SvgUnDrawImage(path: Assets.undraws.empty),
        ),
        SizedBox(height: K.pvmH),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: K.pm * 2),
          child: Text(
            // TODO: text
            message ?? 'Die Liste ist derzeit leer.',
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
