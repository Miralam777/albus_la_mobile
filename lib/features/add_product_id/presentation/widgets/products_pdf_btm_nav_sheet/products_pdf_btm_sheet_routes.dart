import 'package:albus_la_mobile/features/add_product_id/presentation/models/product_group_model.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pdf_utils/models/product_pdf_type_enum.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/gen_qrcode/gen_product.dart';

class ProductsPdfBtmSheetRoutes {
  ProductsPdfBtmSheetRoutes._();
  static const String init = '/';

  static const String locales = '/locales';
  static const String carLabelVersion = '/carLabelVersion';
  static const String keychainVersion = '/keychainVersion';
  static const String cardVersion = '/cardVersion';

  //! arguments
  static ProductPdfType? _pdfType;
  static String? _locale;
  static ProductGroupModel? _group;
  static List<GenProduct> _genProducts = [];

  static ProductPdfType? get pdfType => _pdfType;
  static String? get locale => _locale;
  static List<GenProduct> get genProducts => _genProducts;
  static ProductGroupModel? get group => _group;

  static void setPdfType(ProductPdfType? pdfType) {
    _pdfType = pdfType;
    print('=======>  set _pdfType');
    print('_pdfType: ${_pdfType}');
  }

  static void setLocale(String? locale) {
    _locale = locale;
    print('=======>  set _locale');
    print('_locale: ${_locale}');
  }

  static void setGroupAndGenProducts({
    required ProductGroupModel group,
    required List<GenProduct> genProducts,
  }) {
    _group = group;
    _genProducts = genProducts;
    print('=======>  seted');
    print('_group: ${_group}');
    print('_genProducts: ${_genProducts.length}');
  }

  static void cleanArgs() {
    _pdfType = null;
    _locale = null;
    _group = null;
    _genProducts = [];

    print('=======>  cleaned');
    print('_pdfType: ${_pdfType}');
    print('_locale: ${_locale}');
    print('_group: ${_group}');
    print('_genProducts: ${_genProducts.length}');
  }
}
