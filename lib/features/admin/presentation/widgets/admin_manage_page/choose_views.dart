import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/helpers/view_ids_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseViewsWidget extends StatefulWidget {
  const ChooseViewsWidget({
    super.key,
    required this.viewIds,
    required this.selectedCatsVoidCallback,
  });

  final List<String> viewIds;
  final void Function(List<String>) selectedCatsVoidCallback;

  @override
  State<ChooseViewsWidget> createState() => _SelectViewsWidgetState();
}

class _SelectViewsWidgetState extends State<ChooseViewsWidget> {
  final List<ViewModel> _views = [];

  @override
  void initState() {
    for (var views in ViewIdsHelper.viewsData) {
      _views.add(views.copyWith(selected: widget.viewIds.contains(views.id)));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: K.pm),
          child: Text(
            // TODO: text
            'Ansichten auswählen:',
            maxLines: 2,
            style: textTheme.titleMedium,
          ),
        ),
        (K.pvs.h * 0.5).verticalSpace,
        SizedBox(
          height: 130.0.h,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: K.pm - K.ps * 0.5),
            scrollDirection: Axis.horizontal,
            itemCount: _views.length,
            itemBuilder: (context, int index) {
              final view = _views[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: K.ps * 0.5),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline, width: K.bm),
                  borderRadius: BorderRadius.circular(K.rm),
                ),
                child: Material(
                  color: view.selected
                      ? colorScheme.tertiary.withValues(alpha: 0.2)
                      : colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(K.rm),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      MediaHelper.closeKeyboard(context);

                      setState(() {
                        _views[index] = view.copyWith(selected: !view.selected);
                      });

                      List<String> selectedViewIds = [];
                      for (var view in _views) {
                        if (view.selected) selectedViewIds.add(view.id);
                      }
                      widget.selectedCatsVoidCallback(selectedViewIds);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(K.ps),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(view.icon, size: 27.0.r),
                          5.0.verticalSpace,
                          Text(view.name, style: textTheme.titleSmall),
                          5.0.verticalSpace,
                          Transform.scale(
                            scale: 1.5.r,
                            child: Checkbox(
                              checkColor: Theme.of(context).iconTheme.color,
                              value: view.selected,
                              onChanged: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
