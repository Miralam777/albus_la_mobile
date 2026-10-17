import 'dart:io';

import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/dialogs_utils.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/car_label_pdf_csv_utils.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/widgets/products_pdf_btm_nav_sheet/widgets/creating_dialog.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              leading: Image.asset(
                width: 25.0.r,
                Assets.productImages.carLabelV1.path,
                errorBuilder: (_, _, _) => SizedBox.shrink(),
              ),
              // TODO: text
              title: 'Autoaufkleber V1',
              // TODO: text
              subtitle: 'KFZ-HALTER DIREKT KONTAKTIEREN',
              onTap: () async =>
                  await _onCreatePdf(context, CarLabelPdfCsvType.v1),
            ),

            ProuductsPdfListTile(
              // TODO: iamge
              leading: Image.asset(
                width: 25.0.r,
                Assets.productImages.carLabelV1.path,
                errorBuilder: (_, _, _) => SizedBox.shrink(),
              ),
              // TODO: text
              title: 'Autoaufkleber V2',
              // TODO: text
              subtitle: 'FAHRER DIREKT KONTAKTIEREN',
              onTap: () async =>
                  await _onCreatePdf(context, CarLabelPdfCsvType.v2),
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
    // TODO: remove only for test build
    context.push(Routes.printPdfPage);
    return;
    // TODO: orginal

    String? firstPageVersion; // v1, v2
    if (pdfType == CarLabelPdfCsvType.firstPage) {
      firstPageVersion = await showVersionSelectDialog(context);
      if (firstPageVersion == null) return;
      if (!context.mounted) return;
    }

    final progressNotifier = ValueNotifier<String>('Starting...');

    showCreatingDialog(context, progressNotifier);
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      File? file;

      if (pdfType == CarLabelPdfCsvType.v1) {
        file = await CarLabelPdfCsvUtils.genLabelPdfV1(
          onProgress: (status, current, total) {
            progressNotifier.value = '$status: $current / $total';
          },
        );
      } else if (pdfType == CarLabelPdfCsvType.v2) {
        file = await CarLabelPdfCsvUtils.genLabelPdfV2(
          onProgress: (status, current, total) {
            progressNotifier.value = '$status: $current / $total';
          },
        );
      } else if (pdfType == CarLabelPdfCsvType.list) {
        progressNotifier.value = 'List generiert...';
        file = await CarLabelPdfCsvUtils.genListPdf();
      } else if (pdfType == CarLabelPdfCsvType.firstPage) {
        progressNotifier.value = 'First page generiert...';
        file = await CarLabelPdfCsvUtils.genFirsPagePdf(firstPageVersion!);
      } else if (pdfType == CarLabelPdfCsvType.csv) {
        progressNotifier.value = 'CSV generiert...';
        file = await CarLabelPdfCsvUtils.genCsv();
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

  //! version select dialog
  Future<String?> showVersionSelectDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(K.rl),
          ),
          // TODO: text
          title: const Text('Version wählen', textAlign: TextAlign.center),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
              onPressed: () => context.pop('v1'),
              child: const Text('V1'),
            ),
            TextButton(
              onPressed: () => context.pop('v2'),
              child: const Text('V2'),
            ),
          ],
        );
      },
    );
  }
}
