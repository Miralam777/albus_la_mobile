import 'dart:io';

import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/car_label_pdf_utils.dart';
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
                  await _onCreatePdf(context, CarLabelPdfType.orginal),
            ),
            // TODO:
            ProuductsPdfListTile(
              icon: I.viewList,
              // TODO: text
              title: 'Listenansicht',
              onTap: () async =>
                  await _onCreatePdf(context, CarLabelPdfType.list),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onCreatePdf(
    BuildContext context,
    CarLabelPdfType pdfType,
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

      if (pdfType == CarLabelPdfType.orginal) {
        pdfFile = await CarLabelPdfUtils.genLabelPdf(
          onProgress: (status, current, total) {
            progressNotifier.value = '$status: $current / $total';
          },
        );
      } else if (pdfType == CarLabelPdfType.list) {
        progressNotifier.value = 'Generiert...';

        pdfFile = await CarLabelPdfUtils.genListPdf();
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
