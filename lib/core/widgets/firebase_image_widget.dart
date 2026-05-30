import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'loading_indicator.dart';

import '../../constants/consts.dart';
import '../../constants/icons.dart';

class FirebaseImageWidget extends StatelessWidget {
  const FirebaseImageWidget({
    super.key,
    required this.image,
    this.showLoadingIndicator = true,
    this.fit,
    this.errorWidget,
  });

  final String? image;
  final bool showLoadingIndicator;
  final BoxFit? fit;

  /// by default **'Icon(I.imageNotSupported, size: K.ibs)'**
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    try {
      return Image(
        fit: fit,
        image: FirebaseImageProvider(
          FirebaseUrl(image ?? ''),
          options: const CacheOptions(
            source: Source.cacheServer,
            checkIfFileUpdatedOnServer: false,
          ),
          subDir: "custom_cache_directory",
        ),
        errorBuilder: (_, __, ___) => _errorWidget(),
        loadingBuilder: (_, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return showLoadingIndicator
                ? const LoadingIndicator()
                : const SizedBox.shrink();
          }
        },
      );
    } catch (_) {
      return _errorWidget();
    }
  }

  Widget _errorWidget() {
    return errorWidget ?? Center(child: Icon(I.imageNotSupported, size: K.ibs));
  }
}
