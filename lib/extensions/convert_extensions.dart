import 'package:intl/intl.dart';

extension StringParsing on String? {
  String? toMoney(String? currency) {
    if (this == null) return null;

    final price = double.parse(this!);

    final moneyFormatter =
        NumberFormat.currency(locale: "en_US", symbol: currency ?? "");
    return moneyFormatter.format(price);
  }

  double? toDouble() {
    if (this == null) return null;
    return double.tryParse(this!);
  }
}

extension DoubleParsing on double {
  String toMoney({String? currency}) {
    final moneyFormatter =
        NumberFormat.currency(locale: "en_US", symbol: currency ?? "");
    return moneyFormatter.format(this);
  }
}
