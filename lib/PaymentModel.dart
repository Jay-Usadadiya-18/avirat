/// id : 1
/// username : ""
/// customer_name : "jay bhai"
/// cash_denomination_500 : 2
/// cash_denomination_200 : 2
/// cash_denomination_100 : 2
/// cash_denomination_50 : 2
/// cash_denomination_20 : 0
/// cash_denomination_10 : 0
/// cash_total : "1700.00"
/// uip_image : null
/// cheque_image : null
/// rokda_name : "jaybhua"

class PaymentModel {
  PaymentModel({
    num id,
    String username,
    String customerName,
    num cashDenomination500,
    num cashDenomination200,
    num cashDenomination100,
    num cashDenomination50,
    num cashDenomination20,
    num cashDenomination10,
    String cashTotal,
    dynamic uipImage,
    dynamic chequeImage,
    String rokdaName,
  }) {
    _id = id;
    _username = username;
    _customerName = customerName;
    _cashDenomination500 = cashDenomination500;
    _cashDenomination200 = cashDenomination200;
    _cashDenomination100 = cashDenomination100;
    _cashDenomination50 = cashDenomination50;
    _cashDenomination20 = cashDenomination20;
    _cashDenomination10 = cashDenomination10;
    _cashTotal = cashTotal;
    _uipImage = uipImage;
    _chequeImage = chequeImage;
    cash_amountName = rokdaName;
  }

  PaymentModel.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _customerName = json['customer_name'];
    _cashDenomination500 = json['cash_denomination_500'];
    _cashDenomination200 = json['cash_denomination_200'];
    _cashDenomination100 = json['cash_denomination_100'];
    _cashDenomination50 = json['cash_denomination_50'];
    _cashDenomination20 = json['cash_denomination_20'];
    _cashDenomination10 = json['cash_denomination_10'];
    _cashTotal = json['cash_total'];
    _uipImage = json['uip_image'];
    _chequeImage = json['cheque_image'];
    cash_amountName = json['rokda_name'];
  }

  num _id;
  String _username;
  String _customerName;
  num _cashDenomination500;
  num _cashDenomination200;
  num _cashDenomination100;
  num _cashDenomination50;
  num _cashDenomination20;
  num _cashDenomination10;
  String _cashTotal;
  dynamic _uipImage;
  dynamic _chequeImage;
  String cash_amountName;

  PaymentModel copyWith({
    num id,
    String username,
    String customerName,
    num cashDenomination500,
    num cashDenomination200,
    num cashDenomination100,
    num cashDenomination50,
    num cashDenomination20,
    num cashDenomination10,
    String cashTotal,
    dynamic uipImage,
    dynamic chequeImage,
    String rokdaName,
  }) =>
      PaymentModel(
        id: id ?? _id,
        username: username ?? _username,
        customerName: customerName ?? _customerName,
        cashDenomination500: cashDenomination500 ?? _cashDenomination500,
        cashDenomination200: cashDenomination200 ?? _cashDenomination200,
        cashDenomination100: cashDenomination100 ?? _cashDenomination100,
        cashDenomination50: cashDenomination50 ?? _cashDenomination50,
        cashDenomination20: cashDenomination20 ?? _cashDenomination20,
        cashDenomination10: cashDenomination10 ?? _cashDenomination10,
        cashTotal: cashTotal ?? _cashTotal,
        uipImage: uipImage ?? _uipImage,
        chequeImage: chequeImage ?? _chequeImage,
        rokdaName: rokdaName ?? cash_amountName,
      );

  num get id => _id;

  String get username => _username;

  String get customerName => _customerName;

  num get cashDenomination500 => _cashDenomination500;

  num get cashDenomination200 => _cashDenomination200;

  num get cashDenomination100 => _cashDenomination100;

  num get cashDenomination50 => _cashDenomination50;

  num get cashDenomination20 => _cashDenomination20;

  num get cashDenomination10 => _cashDenomination10;

  String get cashTotal => _cashTotal;

  dynamic get uipImage => _uipImage;

  dynamic get chequeImage => _chequeImage;

  String get rokdaName => cash_amountName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['customer_name'] = _customerName;
    map['cash_denomination_500'] = _cashDenomination500;
    map['cash_denomination_200'] = _cashDenomination200;
    map['cash_denomination_100'] = _cashDenomination100;
    map['cash_denomination_50'] = _cashDenomination50;
    map['cash_denomination_20'] = _cashDenomination20;
    map['cash_denomination_10'] = _cashDenomination10;
    map['cash_total'] = _cashTotal;
    map['uip_image'] = _uipImage;
    map['cheque_image'] = _chequeImage;
    map['rokda_name'] = cash_amountName;
    return map;
  }
}
