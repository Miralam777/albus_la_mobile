extension PriceIntToString on int? {
  String toStringPriceComa() {
    return ((this ?? 0) / 100).toStringAsFixed(2).replaceAll('.', ',');
  }

  String toStringPricePoint() {
    return ((this ?? 0) / 100).toStringAsFixed(2);
  }

  String toStringPriceToAbs() {
    return ((this ?? 0) / 100).abs().toStringAsFixed(2).replaceAll('.', ',');
  }

  String toStringPriceEuro() {
    return '${((this ?? 0) / 100).toStringAsFixed(2)} €'.replaceAll('.', ',');
  }

  String toStringPriceToAbsEuro() {
    return '${(((this ?? 0) / 100).abs()).toStringAsFixed(2)} €'
        .replaceAll('.', ',');
  }

  String toStringPriceEuroMinus() {
    return '-${((this ?? 0) / 100).toStringAsFixed(2)} €'.replaceAll('.', ',');
  }
}
