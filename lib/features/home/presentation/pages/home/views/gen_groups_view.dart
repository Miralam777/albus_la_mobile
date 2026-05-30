import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:albus_la_mobile/features/add_product_id/presentation/models/product_group_model.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/gen_qrcodes_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/gen_qrcode/gen_product.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/product_label_printer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenGroupsView extends StatelessWidget {
  const GenGroupsView({super.key});

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
        title: 'Produkt-Gruppe',
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
      body: _buildGroupStream(),
    );
  }

  Widget _buildGroupStream() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('productGroups')
          .orderBy('created', descending: true) // optional sorting
          .snapshots(),
      builder: (context, snapshot) {
        // Show loading indicator while waiting for the first data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // TODO:
        // Show error message if something went wrong
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading product groups: ${snapshot.error}'),
          );
        }

        // If there is no data or the list is empty, show the empty widget
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const EmptyListWidget();
        }

        // We have data → convert docs to List<ProductGroup>
        final docs = snapshot.data!.docs;
        final List<ProductGroupModel> groups = docs
            .map((doc) => ProductGroupModel.fromMap(doc.data()))
            .toList();

        return _buildGroupsList(context, groups);
      },
    );
  }

  Widget _buildGroupsList(
    BuildContext context,
    List<ProductGroupModel> groups,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIos = PlatformHelper.isIos();

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];

        return Opacity(
          // TODO:
          opacity: 1,
          // opacity: index % 2 == 0 ? 0.5 : 1,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: K.pvsH,
              horizontal: isIos ? K.pm : 0.0,
            ),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: isIos ? BorderRadius.circular(K.rm) : null,
              boxShadow: [
                BoxShadow(color: colorScheme.shadow, blurRadius: 7.0.r),
              ],
            ),
            child: Material(
              /* color: Color.lerp(
                colorScheme.tertiaryContainer,
                Colors.orange,
                !manufactured ? 0.15 : 0,
              ), */
              /*               color: Color.lerp(
                colorScheme.tertiaryContainer,
                Colors.orange,
                index % 2 == 0 ? 0.15 : 0,
              ), */
              color: colorScheme.tertiaryContainer,
              borderRadius: isIos ? BorderRadius.circular(K.rm) : null,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push(Routes.productsPage, extra: group),
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
                          /* Container(
                            height: 90.0.h,
                            width: 90.0.h,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(isIos ? K.rs : K.rm),
                              color: colorScheme.secondaryContainer,
                            ),
                            child: QrImageView(
                              data: '${group.groupNr}',
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
                          ), */
                          K.ps.horizontalSpace,
                          Expanded(
                            child: Column(
                              children: [
                                /* _titleAndText(
                                  context: context,
                                  // TODO: text
                                  title: 'Qr-Code: ',
                                  text: product.id,
                                ), */
                                const Divider(),
                                _titleAndText(
                                  context: context,
                                  // TODO: text
                                  title: 'Name: ',
                                  text: group.name,
                                ),
                                const Divider(),
                                _titleAndText(
                                  context: context,
                                  // TODO: text
                                  title: 'Menge: ',
                                  text: '${group.quantity}',
                                ),
                                const Divider(),
                                _titleAndText(
                                  context: context,
                                  // TODO: text
                                  title: 'Nummer: ',
                                  text: group.groupNr.toString(),
                                ),
                                const Divider(),
                                _titleAndText(
                                  context: context,
                                  // TODO: text
                                  title: 'Datum: ',
                                  text: Helpers.getTimeAndHourFromTimestamp(
                                    group.created,
                                  ),
                                ),
                                const Divider(),
                                _titleAndText(
                                  context: context,
                                  // TODO: text
                                  title: 'Bes.: ',
                                  text: group.description,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      /* if (!manufactured)
                        _buildCreatorWidget(
                          context: context,
                          uId: product.creator,
                          colorScheme: colorScheme,
                        ), */
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
