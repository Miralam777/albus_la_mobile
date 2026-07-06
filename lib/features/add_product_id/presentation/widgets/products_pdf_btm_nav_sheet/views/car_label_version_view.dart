import 'dart:io';

import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/car_label_pdf_csv_utils.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/widgets/products_pdf_btm_nav_sheet/widgets/creating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';

import '../widgets/widgets.dart';

class CarLabelVersionView extends StatelessWidget {
  const CarLabelVersionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PrimaryAppBar(
        // TODO: text
        title: 'Autoaufkleber Version',
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
              icon: I.car,
              // TODO: text
              title: 'Autoaufkleber',
              onTap: () async =>
                  await _onCreatePdf(context, CarLabelPdfCsvType.orginal),
            ),
            // TODO:
            ProuductsPdfListTile(
              icon: I.viewList,
              // TODO: text
              title: 'Listenansicht',
              onTap: () async =>
                  await _onCreatePdf(context, CarLabelPdfCsvType.list),
            ),
            ProuductsPdfListTile(
              icon: I.description,
              // TODO: text
              title: 'Erste Seite',
              onTap: () async =>
                  await _onCreatePdf(context, CarLabelPdfCsvType.firstPage),
            ),
            ProuductsPdfListTile(
              icon: I.csv,
              // TODO: text
              title: 'CSV',
              onTap: () async =>
                  await _onCreatePdf(context, CarLabelPdfCsvType.csv),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCreatePdf(
    BuildContext context,
    CarLabelPdfCsvType pdfType,
  ) async {
    // TODO: remove
    // context.push(Routes.printPdfPage);
    // return;
    // TODO: orginal

    final progressNotifier = ValueNotifier<String>('Starting...');

    showCreatingDialog(context, progressNotifier);
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      File? pdfFile;

      if (pdfType == CarLabelPdfCsvType.orginal) {
        pdfFile = await CarLabelPdfCsvUtils.genLabelPdf(
          onProgress: (status, current, total) {
            progressNotifier.value = '$status: $current / $total';
          },
        );
      } else if (pdfType == CarLabelPdfCsvType.list) {
        progressNotifier.value = 'List generiert...';
        pdfFile = await CarLabelPdfCsvUtils.genListPdf();
      } else if (pdfType == CarLabelPdfCsvType.firstPage) {
        progressNotifier.value = 'First page generiert...';
        pdfFile = await CarLabelPdfCsvUtils.genFirsPagePdf();
      } else if (pdfType == CarLabelPdfCsvType.csv) {
        progressNotifier.value = 'CSV generiert...';
        pdfFile = await CarLabelPdfCsvUtils.genCsv();
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
