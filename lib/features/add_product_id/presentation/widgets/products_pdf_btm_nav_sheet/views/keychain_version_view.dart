import 'dart:io';

import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/keychain_pdf_utils.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/widgets/products_pdf_btm_nav_sheet/widgets/creating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';

import '../widgets/widgets.dart';

class KeychainVersionView extends StatelessWidget {
  const KeychainVersionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PrimaryAppBar(
        // TODO: text
        title: 'Schlüsselanhänger Version',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaHelper.appBarH,
          left: K.pm,
          right: K.pm,
          bottom: K.pvmH,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PdfTypeIconLocaleWidget(withLocale: true),

            ProuductsPdfListTile(
              // TODO: keycain form
              leading: Container(
                height: 22.0.h,
                width: 15.0.r,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              // TODO: text
              title: 'Metal Silver',
              onTap: () async =>
                  await _onCreatePdf(context, KeychainPdfType.metalSliver),
            ),
            // TODO:
            ProuductsPdfListTile(
              icon: I.viewList,
              // TODO: text
              title: 'Listenansicht',
              onTap: () async =>
                  await _onCreatePdf(context, KeychainPdfType.list),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCreatePdf(
    BuildContext context,
    KeychainPdfType pdfType,
  ) async {
    // context.push(Routes.printPdfPage);
    // return;
    final progressNotifier = ValueNotifier<String>('Starting...');

    showCreatingDialog(context, progressNotifier);
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      File? pdfFile;

      if (pdfType == KeychainPdfType.metalSliver) {
        pdfFile = await KeychainPdfUtils.genMetalSilverPdf(
          onProgress: (status, current, total) {
            progressNotifier.value = '$status: $current / $total';
          },
        );
      } else if (pdfType == KeychainPdfType.list) {
        progressNotifier.value = 'Generiert...';
        pdfFile = await KeychainPdfUtils.genListPdf();
      }

      if (!context.mounted) return;
      context.pop();

      if (pdfFile != null) {
        OpenFilex.open(pdfFile.path);
      }
    } catch (e) {
      context.pop();
      // Navigator.pop(context);
      print('Error: $e');
      // TODO: error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e', overflow: TextOverflow.clip)),
      );
    } finally {
      progressNotifier.dispose();
    }
  }
}
