import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/global/user_provider.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/helpers/platform_helper.dart';
import 'package:albus_la_mobile/core/widgets/empty_list_widget.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/printer_status_icon.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/gen_qrcodes_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/gen_qrcode/gen_product.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/product_label_printer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

// TODO: remove
class GenQrcodesView extends StatelessWidget {
  const GenQrcodesView({super.key});

  @override
  Widget build(BuildContext context) {
    final qrcodes = Provider.of<GenQrcodesProvider>(context).getQrcodes;
    final uId = Provider.of<UserProvider>(
      context,
      listen: false,
    ).userInfos?.uId;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PrimaryAppBar(
        // TODO: text
        title: 'Produkt-Qr-Codes',
        leading: Consumer<ProductLabelPrinterProvider>(
          builder: (_, provider, __) {
            return PrinterStatusIcon(isConnected: provider.isConnected);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(I.add),
            onPressed: () => context.push(Routes.addProductGroupPage),
          ),
        ],
      ),
      body: qrcodes.isEmpty
          ? const EmptyListWidget()
          : ListView.builder(
              padding: EdgeInsets.only(
                top: MediaHelper.statusAndAppBarH(context) + K.pvmH,
                bottom: MediaHelper.androidBtmNavBarH(context) + K.pvl2xH,
              ),
              itemCount: qrcodes.length,
              itemBuilder: (_, index) =>
                  _buildCard(context, uId, qrcodes[index]),
            ),
    );
  }

  Widget _buildCard(BuildContext context, String? uId, GenProduct product) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIos = PlatformHelper.isIos();
    final manufactured = product.manufactured ?? false;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: K.pvsH,
        horizontal: isIos ? K.pm : 0.0,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: isIos ? BorderRadius.circular(K.rm) : null,
        boxShadow: [BoxShadow(color: colorScheme.shadow, blurRadius: 7.0.r)],
      ),
      child: Material(
        color: Color.lerp(
          colorScheme.tertiaryContainer,
          Colors.orange,
          !manufactured ? 0.15 : 0,
        ),
        borderRadius: isIos ? BorderRadius.circular(K.rm) : null,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (manufactured) {
              context.push(
                Routes.addProductIdPage,
                extra: {'manufactured': true, 'genProduct': product},
              );
            }
            if (!manufactured && uId == product.creator) {
              context.push(
                Routes.addProductIdPage,
                extra: {'genProduct': product},
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isIos ? K.ps : K.pm,
              vertical: K.pvmH,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 90.0.h,
                      width: 90.0.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          isIos ? K.rs : K.rm,
                        ),
                        color: colorScheme.secondaryContainer,
                      ),
                      child: QrImageView(
                        data: product.id ?? '',
                        version: QrVersions.auto,
                        /* eyeStyle: QrEyeStyle(
                           color: manufactured ? Colors.black : Colors.orange,
                          eyeShape: QrEyeShape.square,
                        ), */
                        /* dataModuleStyle: QrDataModuleStyle(
                          color: manufactured ? Colors.black : Colors.orange,
                          dataModuleShape: QrDataModuleShape.square,
                        ), */
                        size: 200.0.r,
                      ),
                    ),
                    K.ps.horizontalSpace,
                    Expanded(
                      child: Column(
                        children: [
                          _titleAndText(
                            context: context,
                            // TODO: text
                            title: 'Qr-Code: ',
                            text: product.id,
                          ),
                          const Divider(),
                          _titleAndText(
                            context: context,
                            // TODO: text
                            title: 'B-Name: ',
                            text: product.name,
                          ),
                          const Divider(),
                          _titleAndText(
                            context: context,
                            // TODO: text
                            title: 'P-ID: ',
                            text: product.productId.toString(),
                          ),
                          const Divider(),
                          _titleAndText(
                            context: context,
                            // TODO: text
                            title: 'Datum: ',
                            text: Helpers.getTimeAndHourFromTimestamp(
                              product.createdAt,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!manufactured)
                  _buildCreatorWidget(
                    context: context,
                    uId: product.creator,
                    colorScheme: colorScheme,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildCreatorWidget({
    required BuildContext context,
    required String? uId,
    required ColorScheme colorScheme,
  }) {
    final admin = Provider.of<UserProvider>(
      context,
      listen: false,
    ).getAdminByUId(uId);

    return Padding(
      padding: EdgeInsets.only(top: K.pvsH),
      child: Row(
        children: [
          SizedBox(width: 90.0.h + K.ps.w),
          CircleAvatar(
            maxRadius: 20.0.r,
            backgroundColor: colorScheme.secondaryContainer,
            foregroundColor: Theme.of(context).iconTheme.color,
            child: Icon(I.person),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              '${admin?.firstname} ${admin?.surname}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Row _titleAndText({
    required BuildContext context,
    required String title,
    required String? text,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(text ?? '', style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
