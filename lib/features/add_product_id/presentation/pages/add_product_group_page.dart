import 'package:albus_la_mobile/configs/services/firebase/firestore_service.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/bloc_events_helper.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/page_stack_loading.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/svg_un_draw_image.dart';
import 'package:albus_la_mobile/core/widgets/text_field.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/models/product_group_model.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddProductGroupPage extends StatefulWidget {
  const AddProductGroupPage({super.key});

  @override
  State<AddProductGroupPage> createState() => _AddProductGroupPageState();
}

class _AddProductGroupPageState extends State<AddProductGroupPage> {
  late TextEditingController _tecName,
      _tecQuantity,
      _tecValidityYears,
      _tecDescription;

  bool _nameTecError = false;
  bool _quantityTecError = false;
  bool _validityYearsTecError = false;

  bool _isAdding = false;
  int _uploadPercent = 0;

  bool _deletable = false;

  @override
  void initState() {
    _tecName = TextEditingController();
    _tecQuantity = TextEditingController();
    _tecValidityYears = TextEditingController();
    _tecDescription = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _tecName.dispose();
    _tecQuantity.dispose();
    _tecValidityYears.dispose();
    _tecDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_isAdding,
      child: PageStackLoading(
        scaffold: Scaffold(
          extendBodyBehindAppBar: true,
          // extendBody: true,
          appBar: PrimaryAppBar(
            // TODO: text
            title: 'Gruppe hinzufügen',
            actions: [
              /*               IconButton(
                icon: Icon(I.printer),
                onPressed: () async {
                  // await showAddProductGroupBtmNavSheet(context: context);
                },
              ), */
              /*           IconButton(
                    icon: Icon(I.add),
                    onPressed: () async {
                      await showAddProductGroupBtmNavSheet(context: context);
                    },
                  ) */
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: K.pm),
            child: Column(
              children: [
                (MediaHelper.statusAndAppBarH(context) + K.pvm).verticalSpace,
                SvgUnDrawImage(path: Assets.undraws.productIteration),
                K.pvm.verticalSpace,
                TextFieldWidget(
                  controller: _tecName,
                  // TODO: text
                  hintText: 'Name*',
                  // TODO: text
                  errorText: _nameTecError ? 'Pflichtfeld*' : null,
                  maxLength: 50,
                  onChanged: (val) {
                    if (_nameTecError && (val ?? '').isNotEmpty) {
                      setState(() => _nameTecError = false);
                    }
                  },
                ),
                K.pvm.verticalSpace,
                TextFieldWidget(
                  controller: _tecQuantity,
                  // TODO: text
                  hintText: 'Menge',
                  keyType: TextInputType.datetime,
                  suffixIcon: I.size,
                  // TODO: text
                  errorText: _quantityTecError
                      ? 'Es muss eine ganze Zahl sein.'
                      : null,
                  // TODO: text
                  helperText: 'z. B. 100 oder 1000',
                  maxLength: 5,
                  onChanged: (val) {
                    if (_quantityTecError && (val ?? '').isNotEmpty) {
                      setState(() => _quantityTecError = false);
                    }
                  },
                ),
                K.pvm.verticalSpace,
                TextFieldWidget(
                  controller: _tecValidityYears,
                  // TODO: text
                  hintText: 'Gültigkeitsjahre',
                  keyType: TextInputType.datetime,
                  suffixIcon: I.size,
                  // TODO: text
                  errorText: _validityYearsTecError
                      ? 'Es muss eine ganze Zahl sein.'
                      : null,
                  // TODO: text
                  helperText: 'z. B. 5 oder 10 Jahre',
                  maxLength: 2,
                  onChanged: (val) {
                    if (_validityYearsTecError && (val ?? '').isNotEmpty) {
                      setState(() => _validityYearsTecError = false);
                    }
                  },
                ),
                K.pvm.verticalSpace,
                TextFieldWidget(
                  controller: _tecDescription,
                  // TODO: text
                  hintText: 'Beschreibung',
                  suffixIcon: I.description,
                  // TODO: text
                  maxLength: 500,
                  minLines: 3,
                  maxLines: 5,
                ),
                K.pvm.verticalSpace,
                ListTile(
                  // contentPadding: EdgeInsets.zero,
                  title: Text(
                    // TODO: text,
                    'Löschen erlauben',
                  ),
                  // TODO: text,
                  subtitle: Text(
                    'Erlaubt das Löschen von Produkten dieser Gruppe.',
                    overflow: TextOverflow.clip,
                  ),
                  trailing: Switch(
                    value: _deletable,
                    onChanged: (val) => setState(() => _deletable = val),
                  ),
                ),
                K.pvl2x.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(I.add),
                    // TODO: text
                    label: const Text('Hinzufügen'),
                    onPressed: _onAdd,
                  ),
                ),
                (MediaHelper.androidBtmNavBarH(context) + K.pvl).verticalSpace,
              ],
            ),
          ),
        ),
        visible: _isAdding,
        undrawPath: Assets.undraws.upload,
        // TODO: text
        title: 'Bitte warten, Upload läuft.',
        children: [
          LinearProgressIndicator(
            value: _uploadPercent / 100,
            borderRadius: BorderRadius.circular(50),
            minHeight: 7.0.h,
            backgroundColor: Theme.of(context).cardColor,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ],
      ),
    );
  }

  void _onAdd() async {
    MediaHelper.closeKeyboard(context);

    //! name check
    if (_tecName.text.trim().isEmpty) {
      setState(() => _nameTecError = true);
      return;
    }

    //! quantity check
    final trimedQuantity = _tecQuantity.text.trim();
    int? quantityInt = int.tryParse(trimedQuantity);
    print('quantityInt: $quantityInt');
    if (quantityInt == null) {
      setState(() => _quantityTecError = true);
      return;
    }

    //! validity years check
    final trimedValidityYears = _tecValidityYears.text.trim();
    int? validityYearsInt = int.tryParse(trimedValidityYears);
    print('validityYearsInt: $validityYearsInt');
    if (validityYearsInt == null) {
      setState(() => _validityYearsTecError = true);
      return;
    }

    setState(() => _isAdding = true);

    final uId = BlocEventsHelper.getSettings(context).uId;

    await FirestoreService.addGroupAndProducts(
      ProductGroupModel(
        creator: uId,
        name: _tecName.text.trim(),
        quantity: quantityInt,
        validityYears: validityYearsInt,
        description: _tecDescription.text.trim(),
        deletable: _deletable,
        // TODO:
        pName: 'Carlabel',
        // TODO:
        pId: 123456789,
        // TODO:
        pType: 1,
      ),
      (percent) {
        print('=======> percent: $percent');
        setState(() => _uploadPercent = percent);
      },
    );

    print(!mounted);
    print('context.pop()');
    if (!mounted) return;
    context.pop();
  }
}
