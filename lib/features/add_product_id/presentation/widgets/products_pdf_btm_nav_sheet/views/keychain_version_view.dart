import 'dart:io';

import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/keychain_pdf_csv_utils.dart';
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
                  await _onCreatePdf(context, KeychainPdfCsvType.metalSliver),
            ),
            // TODO:
            ProuductsPdfListTile(
              icon: I.viewList,
              // TODO: text
              title: 'Listenansicht',
              onTap: () async =>
                  await _onCreatePdf(context, KeychainPdfCsvType.list),
            ),

            ProuductsPdfListTile(
              icon: I.description,
              // TODO: text
              title: 'Erste Seite',
              onTap: () async =>
                  await _onCreatePdf(context, KeychainPdfCsvType.firstPage),
            ),

            ProuductsPdfListTile(
              icon: I.csv,
              // TODO: text
              title: 'CSV',
              onTap: () async =>
                  await _onCreatePdf(context, KeychainPdfCsvType.csv),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCreatePdf(
    BuildContext context,
    KeychainPdfCsvType pdfType,
  ) async {
    // TODO: remove only for test build
    // context.push(Routes.printPdfPage);
    // return;
    // TODO: orginal

    final progressNotifier = ValueNotifier<String>('Starting...');

    showCreatingDialog(context, progressNotifier);
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      File? file;

      if (pdfType == KeychainPdfCsvType.metalSliver) {
        file = await KeychainPdfCsvUtils.genMetalSilverPdf(
          onProgress: (status, current, total) {
            progressNotifier.value = '$status: $current / $total';
          },
        );
      } else if (pdfType == KeychainPdfCsvType.list) {
        progressNotifier.value = 'List generiert...';
        file = await KeychainPdfCsvUtils.genListPdf();
      } else if (pdfType == KeychainPdfCsvType.firstPage) {
        progressNotifier.value = 'First page generiert...';
        file = await KeychainPdfCsvUtils.genFirsPagePdf();
      } else if (pdfType == KeychainPdfCsvType.csv) {
        progressNotifier.value = 'CSV generiert...';
        file = await KeychainPdfCsvUtils.genCsv();
      }

      if (!context.mounted) return;
      context.pop();

      if (file != null) {
        OpenFilex.open(file.path);
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
