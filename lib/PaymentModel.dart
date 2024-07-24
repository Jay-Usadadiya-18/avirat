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
    this.id,
    this.username,
    this.customerName,
    this.cashDenomination500,
    this.cashDenomination200,
    this.cashDenomination100,
    this.cashDenomination50,
    this.cashDenomination20,
    this.cashDenomination10,
    this.cashTotal,
    this.uipImage,
    this.chequeImage,
    this.rokdaName,
  });

  PaymentModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        customerName = json['customer_name'],
        cashDenomination500 = json['cash_denomination_500'],
        cashDenomination200 = json['cash_denomination_200'],
        cashDenomination100 = json['cash_denomination_100'],
        cashDenomination50 = json['cash_denomination_50'],
        cashDenomination20 = json['cash_denomination_20'],
        cashDenomination10 = json['cash_denomination_10'],
        cashTotal = json['cash_total'],
        uipImage = json['uip_image'],
        chequeImage = json['cheque_image'],
        rokdaName = json['rokda_name'];

  num? id;
  String? username;
  String? customerName;
  num? cashDenomination500;
  num? cashDenomination200;
  num? cashDenomination100;
  num? cashDenomination50;
  num? cashDenomination20;
  num? cashDenomination10;
  String? cashTotal;
  dynamic uipImage;
  dynamic chequeImage;
  String? rokdaName;

  PaymentModel copyWith({
    num? id,
    String? username,
    String? customerName,
    num? cashDenomination500,
    num? cashDenomination200,
    num? cashDenomination100,
    num? cashDenomination50,
    num? cashDenomination20,
    num? cashDenomination10,
    String? cashTotal,
    dynamic? uipImage,
    dynamic? chequeImage,
    String? rokdaName,
  }) =>
      PaymentModel(
        id: id ?? this.id,
        username: username ?? this.username,
        customerName: customerName ?? this.customerName,
        cashDenomination500: cashDenomination500 ?? this.cashDenomination500,
        cashDenomination200: cashDenomination200 ?? this.cashDenomination200,
        cashDenomination100: cashDenomination100 ?? this.cashDenomination100,
        cashDenomination50: cashDenomination50 ?? this.cashDenomination50,
        cashDenomination20: cashDenomination20 ?? this.cashDenomination20,
        cashDenomination10: cashDenomination10 ?? this.cashDenomination10,
        cashTotal: cashTotal ?? this.cashTotal,
        uipImage: uipImage ?? this.uipImage,
        chequeImage: chequeImage ?? this.chequeImage,
        rokdaName: rokdaName ?? this.rokdaName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['customer_name'] = customerName;
    map['cash_denomination_500'] = cashDenomination500;
    map['cash_denomination_200'] = cashDenomination200;
    map['cash_denomination_100'] = cashDenomination100;
    map['cash_denomination_50'] = cashDenomination50;
    map['cash_denomination_20'] = cashDenomination20;
    map['cash_denomination_10'] = cashDenomination10;
    map['cash_total'] = cashTotal;
    map['uip_image'] = uipImage;
    map['cheque_image'] = chequeImage;
    map['rokda_name'] = rokdaName;
    return map;
  }
}
