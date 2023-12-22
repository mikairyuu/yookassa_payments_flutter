import 'currency.dart';

class Amount {
  String value;
  Currency currency;

  Amount({required this.value, required this.currency});

  Map<String, dynamic> toJson() =>
      {
        'value': value,
        'currency': currency.value
      };
}