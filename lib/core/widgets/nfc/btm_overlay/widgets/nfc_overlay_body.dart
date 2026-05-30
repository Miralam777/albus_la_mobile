import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/global/nfc_notifier.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../ripple_animation.dart';

enum NfcSheetState { notAvailable, loading, success, error }

enum AnimatedIconType { check, exclamation, cross }

class NfcOverlayBody extends StatefulWidget {
  const NfcOverlayBody({
    super.key,
    this.isWrite = false,
    required this.state,
    required this.isAvailable,
    required this.onTryAgain,
    this.onSuccessShown,
    required this.onCloseAnimationDone,
  });

  final bool isWrite;
  final NfcSheetState state;
  final bool? isAvailable;
  final void Function() onTryAgain;
  final void Function()? onSuccessShown;
  final void Function() onCloseAnimationDone;

  @override
  State<NfcOverlayBody> createState() => _NfcOverlayBodyState();
}

class _NfcOverlayBodyState extends State<NfcOverlayBody>
    with TickerProviderStateMixin {
  // Sheet animation
  late AnimationController _sheetController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Success/Error icon animation
  late AnimationController _iconController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _initSheetAnimation();
    _initIconAnimation();
    _sheetController.forward();
  }

  void _initSheetAnimation() {
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _sheetController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _sheetController, curve: Curves.easeOut));
  }

  void _initIconAnimation() {
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
        ]).animate(
          CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
        );

    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _iconController.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          widget.state == NfcSheetState.success) {
        widget.onSuccessShown?.call();
        Future.delayed(const Duration(milliseconds: 1500), () async {
          _closeSheet(stopSessionImmediately: false);
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant NfcOverlayBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate on success
    if (widget.state == NfcSheetState.success &&
        oldWidget.state != NfcSheetState.success) {
      try {
        _iconController.reset();
        _iconController.forward();
      } catch (_) {}
    }

    // Animate on error
    if (widget.state == NfcSheetState.error &&
        oldWidget.state != NfcSheetState.error) {
      try {
        _iconController.reset();
        _iconController.forward();
      } catch (_) {}
    }
  }

  Future<void> _closeSheet({bool stopSessionImmediately = true}) async {
    try {
      await _sheetController.reverse();
    } catch (_) {}

    widget.onCloseAnimationDone.call();

    if (!mounted) return;
    context.read<NfcNotifier>().stopSession(
      immediately: stopSessionImmediately,
    );
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _closeSheet();
      },
      child: Stack(
        children: [
          // Barrier
          FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: () => _closeSheet(),
              child: const ColoredBox(
                color: Colors.black54,
                child: SizedBox.expand(),
              ),
            ),
          ),

          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: MediaHelper.w(context) - K.pm,
                margin: EdgeInsets.only(
                  bottom: MediaHelper.androidBtmNavBarH(context),
                ),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Theme.of(context).bottomSheetTheme.backgroundColor,
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(K.rl),
                ),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: K.pm),
                  child: Column(
                    children: [
                      K.pvl.verticalSpace,

                      // Title
                      Text(
                        _getTitle(),
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      // Middle Icon
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: K.pvl2xH),
                        child: _buildMiddleIcon(context),
                      ),

                      // Subtitle
                      Text(
                        _getSubtitle(),
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      K.pvl.verticalSpace,

                      // Button
                      if (widget.state != NfcSheetState.success)
                        SizedBox(
                          width: double.infinity,
                          child: widget.state == NfcSheetState.error
                              ? ElevatedButton.icon(
                                  icon: const Icon(I.sync),
                                  label: const Text(
                                    // TODO: text
                                    // S.of(context).gwNfcOverlayTryAgainBtnTitle,
                                    'Erneut versuchen',
                                  ),
                                  onPressed: widget.onTryAgain,
                                )
                              : ElevatedButton(
                                  child: const Text(
                                    // TODO: text
                                    // S.of(context).gwNfcOverlayCancelBtnTitle,
                                    'Abbrechen',
                                  ),
                                  onPressed: () async => await _closeSheet(),
                                ),
                        ),

                      if (widget.state == NfcSheetState.error) ...[
                        K.pvsx.verticalSpace,
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).colorScheme.error,
                              ),
                            ),
                            child: const Text(
                              // TODO: text
                              // S.of(context).gwNfcOverlayCancelBtnTitle,
                              'Abbrechen',
                            ),
                            onPressed: () async => await _closeSheet(),
                          ),
                        ),
                      ],

                      K.pvl.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TODO: text
  /*   String _getTitle() {
    if (widget.isAvailable == false) {
      return S.of(context).gwNfcOverlayTitle(NfcSheetState.notAvailable.name);
    }

    return switch (widget.state) {
      NfcSheetState.loading =>
        S.of(context).gwNfcOverlayTitle(NfcSheetState.loading.name),
      NfcSheetState.success => S
          .of(context)
          .gwNfcOverlayTitle(widget.isWrite ? 'successWrite' : 'successRead'),
      NfcSheetState.error =>
        S.of(context).gwNfcOverlayTitle(NfcSheetState.error.name),
      _ => '',
    };
  } */

  String _getTitle() {
    if (widget.isAvailable == false) {
      return 'NFC ist ausgeschaltet';
    }

    return switch (widget.state) {
      NfcSheetState.loading =>
        widget.isWrite ? 'Bereit zum Schreiben' : 'Bereit zum Scannen',
      NfcSheetState.success =>
        widget.isWrite ? 'Erfolgreich geschrieben!' : 'Erfolgreich gescannt!',
      NfcSheetState.error => 'NFC-Tag nicht kompatibel',
      _ => '',
    };
  }

  // TODO: text
  /*   String _getSubtitle() {
    return switch (widget.state) {
      NfcSheetState.loading =>
        S.of(context).gwNfcOverlaySubtitle(NfcSheetState.loading.name),
      NfcSheetState.error =>
        S.of(context).gwNfcOverlaySubtitle(NfcSheetState.error.name),
      _ => '',
    };
  } */

  String _getSubtitle() {
    return switch (widget.state) {
      NfcSheetState.loading => 'Nähere dich dem NFC-Tag',
      NfcSheetState.error => 'Bitte versuche es erneut',
      _ => '',
    };
  }

  Widget _buildMiddleIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return switch (widget.state) {
      NfcSheetState.loading => RippleAnimation(
        repeat: true,
        minRadius: 60.0.r,
        child: _buildIconContainer(
          context: context,
          color: colorScheme.primary,
          icon: widget.isWrite ? I.nfc : I.contactless,
        ),
      ),
      NfcSheetState.success => ScaleTransition(
        scale: _scaleAnimation,
        child: _buildAnimatedIcon(
          context: context,
          color: colorScheme.primary,
          iconType: AnimatedIconType.check,
        ),
      ),
      NfcSheetState.error => ScaleTransition(
        scale: _scaleAnimation,
        child: _buildAnimatedIcon(
          context: context,
          color: colorScheme.error,
          iconType: AnimatedIconType.exclamation,
        ),
      ),
      _ => _buildIconContainer(
        context: context,
        color: colorScheme.outline,
        icon: I.nfc,
      ),
    };
  }

  Widget _buildIconContainer({
    required BuildContext context,
    required Color color,
    required IconData icon,
    Color? borderColor,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(K.pm),
        child: Icon(icon, size: K.ibs * 2, color: color),
      ),
    );
  }

  Widget _buildAnimatedIcon({
    required BuildContext context,
    required Color color,
    required AnimatedIconType iconType,
  }) {
    return Container(
      padding: EdgeInsets.all(K.pm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: AnimatedBuilder(
        animation: _iconAnimation,
        builder: (context, child) {
          return CustomPaint(
            size: Size(K.ibs * 2, K.ibs * 2),
            painter: _AnimatedIconPainter(
              progress: _iconAnimation.value,
              color: color,
              iconType: iconType,
            ),
          );
        },
      ),
    );
  }
}

/// Custom Painter for animated icons (check, exclamation, cross)
class _AnimatedIconPainter extends CustomPainter {
  final double progress;
  final Color color;
  final AnimatedIconType iconType;

  _AnimatedIconPainter({
    required this.progress,
    required this.color,
    required this.iconType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    switch (iconType) {
      case AnimatedIconType.check:
        _drawCheckmark(canvas, size, paint);
        break;
      case AnimatedIconType.exclamation:
        _drawExclamation(canvas, size, paint);
        break;
      case AnimatedIconType.cross:
        _drawCross(canvas, size, paint);
        break;
    }
  }

  void _drawCheckmark(Canvas canvas, Size size, Paint paint) {
    final path = Path();

    final start = Offset(size.width * 0.2, size.height * 0.5);
    final middle = Offset(size.width * 0.45, size.height * 0.7);
    final end = Offset(size.width * 0.8, size.height * 0.3);

    if (progress <= 0.5) {
      final p = progress * 2;
      path.moveTo(start.dx, start.dy);
      path.lineTo(
        start.dx + (middle.dx - start.dx) * p,
        start.dy + (middle.dy - start.dy) * p,
      );
    } else {
      path.moveTo(start.dx, start.dy);
      path.lineTo(middle.dx, middle.dy);

      final p = (progress - 0.5) * 2;
      path.lineTo(
        middle.dx + (end.dx - middle.dx) * p,
        middle.dy + (end.dy - middle.dy) * p,
      );
    }

    canvas.drawPath(path, paint);
  }

  void _drawExclamation(Canvas canvas, Size size, Paint paint) {
    final centerX = size.width / 2;

    // Line (top)
    final lineTop = Offset(centerX, size.height * 0.15);
    final lineBottom = Offset(centerX, size.height * 0.6);

    // Dot (bottom)
    final dotCenter = Offset(centerX, size.height * 0.8);
    final dotRadius = size.width * 0.06;

    if (progress <= 0.7) {
      // Animate line
      final p = progress / 0.7;
      final currentBottom = Offset(
        lineTop.dx,
        lineTop.dy + (lineBottom.dy - lineTop.dy) * p,
      );
      canvas.drawLine(lineTop, currentBottom, paint);
    } else {
      // Line complete
      canvas.drawLine(lineTop, lineBottom, paint);

      // Animate dot
      final p = (progress - 0.7) / 0.3;
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(dotCenter, dotRadius * p, fillPaint);
    }
  }

  void _drawCross(Canvas canvas, Size size, Paint paint) {
    final padding = size.width * 0.2;

    final topLeft = Offset(padding, padding);
    final topRight = Offset(size.width - padding, padding);
    final bottomLeft = Offset(padding, size.height - padding);
    final bottomRight = Offset(size.width - padding, size.height - padding);

    if (progress <= 0.5) {
      // First line (topLeft -> bottomRight)
      final p = progress * 2;
      final currentEnd = Offset(
        topLeft.dx + (bottomRight.dx - topLeft.dx) * p,
        topLeft.dy + (bottomRight.dy - topLeft.dy) * p,
      );
      canvas.drawLine(topLeft, currentEnd, paint);
    } else {
      // First line complete
      canvas.drawLine(topLeft, bottomRight, paint);

      // Second line (topRight -> bottomLeft)
      final p = (progress - 0.5) * 2;
      final currentEnd = Offset(
        topRight.dx + (bottomLeft.dx - topRight.dx) * p,
        topRight.dy + (bottomLeft.dy - topRight.dy) * p,
      );
      canvas.drawLine(topRight, currentEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedIconPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.iconType != iconType ||
        oldDelegate.color != color;
  }
}
