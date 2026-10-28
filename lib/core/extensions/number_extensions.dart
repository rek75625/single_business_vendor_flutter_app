import 'package:intl/intl.dart';
import 'package:single_business_vendor_flutter_app/core/constants/app_constants.dart';

extension NumberExtensions on num {
  String toCurrency() {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '${formatter.format(this)} ${AppConstants.currencySymbol}';
  }

  String toCompact() {
    final formatter = NumberFormat.compact();
    return formatter.format(this);
  }
}
