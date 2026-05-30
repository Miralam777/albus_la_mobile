import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/consts.dart';
import '../../constants/icons.dart';

class SvgUnDrawImage extends StatelessWidget {
  const SvgUnDrawImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.color,
    this.padding,
    this.isOrginal = false,
  });

  /// svg image path from assets
  final String path;

  /// default height 200.0.h
  final double? height;

  /// default width double.infinity
  final double? width;

  /// default color theme secondary
  final Color? color;

  /// default padding all [K.pm]
  final EdgeInsetsGeometry? padding;

  /// default to false
  final bool isOrginal;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height ?? 200.0.h,
      width: width ?? double.infinity,
      padding: padding ?? EdgeInsets.all(K.pm),
      child: FutureBuilder<String>(
        future: _renderImage(colorScheme, path, isOrginal),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            return _errorIcon();
          } else if (snapshot.hasData) {
            return SvgPicture.string(
              '${snapshot.data}',
              alignment: Alignment.center,
              fit: BoxFit.contain,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Center _errorIcon() => Center(
    child: Icon(I.error, size: K.ibs, color: Colors.red),
  );

  Future<String> _renderImage(
    ColorScheme colorScheme,
    String svgPath,
    bool isOrginal,
  ) async {
    final image = await rootBundle.loadString(svgPath);
    if (isOrginal) return image;

    String secondaryValue = _getColorValue(color ?? colorScheme.secondary);
    String primaryContainerValue = _getColorValue(colorScheme.primaryContainer);
    String secondaryContainerValue = _getColorValue(
      colorScheme.secondaryContainer,
    );
    String tertiaryContainerValue = _getColorValue(
      colorScheme.tertiaryContainer,
    );

    final newImage = image
        .replaceAll("#6c63ff", secondaryValue)
        .replaceAll("#fff", primaryContainerValue)
        .replaceAll("#ccc", primaryContainerValue)
        .replaceAll("#f0f0f0", secondaryContainerValue)
        .replaceAll("#e6e6e6", secondaryContainerValue)
        .replaceAll("#e5e5e5", secondaryContainerValue)
        .replaceAll("#f2f2f2", tertiaryContainerValue);

    return newImage;
  }

  String _getColorValue(Color color) {
    final value = color.value.toRadixString(16).padLeft(8, '0');
    return '#${value.substring(2)}';
  }
}

// primary = #6c63ff
// primaryContainer = #fff
//    && #ccc / grand
// secondaryContainer = #f0f0f0
//    && #e6e6e6 /clodes
//    && #e5e5e5 /more information circel
// tertieryContainer = #f2f2f2

// TODO: coment at end
class SvgImageTests extends StatelessWidget {
  const SvgImageTests({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _images(Assets.undraws.adventure),
        _images(Assets.undraws.building),
        _images(Assets.undraws.creditCardPayments),
        _images(Assets.undraws.empty),
        _images(Assets.undraws.mobileLogin),
        _images(Assets.undraws.myPassword),
        _images(Assets.undraws.newMessage),
        _images(Assets.undraws.notFound),
        _images(Assets.undraws.notify),
        _images(Assets.undraws.onlinePayments),
        _images(Assets.undraws.personalInformation),
        _images(Assets.undraws.pushNotifications),
        _images(Assets.undraws.secureServer),
        _images(Assets.undraws.settings),
        _images(Assets.undraws.termSheet),
        _images(Assets.undraws.thingsToSay),
        _images(Assets.undraws.warning),
      ],
    );
  }

  Widget _images(String path) {
    return Row(
      children: [
        Expanded(child: SvgUnDrawImage(path: path)),
        Expanded(child: SvgUnDrawImage(path: path, isOrginal: true)),
      ],
    );
  }
}

// TODO: coment at end
/* class UnDrawImage extends StatelessWidget {
  const UnDrawImage({
    super.key,
    required this.unDrawIllustration,
    this.height,
  });
  final UnDrawIllustration unDrawIllustration;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 200.0.h,
      child: UnDraw(
        color: Theme.of(context).colorScheme.secondary,
        illustration: unDrawIllustration,
        placeholder: Text("Illustration is loading..."),
      ),
    );
  }
} */
