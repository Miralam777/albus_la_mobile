import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';
import 'package:albus_la_mobile/core/widgets/note_text.dart';
import 'package:albus_la_mobile/core/widgets/svg_un_draw_image.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageCard extends StatefulWidget {
  const PageCard({
    super.key,
    required this.svgImage,
    required this.docId,
    this.borderRadius,
    this.margin,
  });

  final String svgImage;
  final String docId;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  @override
  State<PageCard> createState() => _PageCardState();
}

class _PageCardState extends State<PageCard>
    with AutomaticKeepAliveClientMixin {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: 10,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: widget.borderRadius,
      ),
      child: StreamBuilder(
        stream: fireStore
            .collection('rechtliches')
            .doc(widget.docId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data?.data();
            final html = data?['html'] as String?;
            // TODO: use html widget
            return _htmWidget(html);
          } else if (snapshot.hasError) {
            return _errorWidget();
          } else {
            return const LoadingIndicator();
          }
        },
      ),
    );
  }

  SingleChildScrollView _htmWidget(String? html) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: K.pm,
        right: K.pm,
        top: K.pm,
        // TODO: bottom padding
        bottom: 100.0.h,
      ),
      child: Column(
        children: [
          SvgUnDrawImage(path: widget.svgImage, height: 250.0.h),
          Text(
            html ?? 'Value is null',
            textAlign: TextAlign.justify,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }

  Widget _errorWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: K.pm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgUnDrawImage(path: Assets.undraws.secureServer, height: 250.0.h),
          NoteTextWidget(
            // TODO: text
            text: 'Derzeit keine Verbindung zum Server.',
          ),
        ],
      ),
    );
  }
}
