/// id : 1
/// username : "bhargavbhai"
/// name : "bhargavbhai"
/// mobile_number : "123457"
/// panel_brand : "Adani"
/// panel_quality : "2"
/// inverter_brand : "PVLink"
/// panel_watt : 555
/// light_bill_image : null
/// passbook_image : null
/// pan_card_image : null

class PostModel {
  PostModel({
    num id,
    String username,
    String name,
    String mobileNumber,
    String panelBrand,
    String panelQuality,
    String inverterBrand,
    num panelWatt,
    dynamic lightBillImage,
    dynamic passbookImage,
    dynamic panCardImage,
  }) {
    _id = id;
    _username = username;
    _name = name;
    _mobileNumber = mobileNumber;
    _panelBrand = panelBrand;
    _panelQuality = panelQuality;
    _inverterBrand = inverterBrand;
    _panelWatt = panelWatt;
    _lightBillImage = lightBillImage;
    _passbookImage = passbookImage;
    _panCardImage = panCardImage;
  }

  PostModel.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _name = json['name'];
    _mobileNumber = json['mobile_number'];
    _panelBrand = json['panel_brand'];
    _panelQuality = json['panel_quality'];
    _inverterBrand = json['inverter_brand'];
    _panelWatt = json['panel_watt'];
    _lightBillImage = json['light_bill_image'];
    _passbookImage = json['passbook_image'];
    _panCardImage = json['pan_card_image'];
  }

  num _id;
  String _username;
  String _name;
  String _mobileNumber;
  String _panelBrand;
  String _panelQuality;
  String _inverterBrand;
  num _panelWatt;
  dynamic _lightBillImage;
  dynamic _passbookImage;
  dynamic _panCardImage;

  PostModel copyWith({
    num id,
    String username,
    String name,
    String mobileNumber,
    String panelBrand,
    String panelQuality,
    String inverterBrand,
    num panelWatt,
    dynamic lightBillImage,
    dynamic passbookImage,
    dynamic panCardImage,
  }) =>
      PostModel(
        id: id ?? _id,
        username: username ?? _username,
        name: name ?? _name,
        mobileNumber: mobileNumber ?? _mobileNumber,
        panelBrand: panelBrand ?? _panelBrand,
        panelQuality: panelQuality ?? _panelQuality,
        inverterBrand: inverterBrand ?? _inverterBrand,
        panelWatt: panelWatt ?? _panelWatt,
        lightBillImage: lightBillImage ?? _lightBillImage,
        passbookImage: passbookImage ?? _passbookImage,
        panCardImage: panCardImage ?? _panCardImage,
      );

  num get id => _id;

  String get username => _username;

  String get name => _name;

  String get mobileNumber => _mobileNumber;

  String get panelBrand => _panelBrand;

  String get panelQuality => _panelQuality;

  String get inverterBrand => _inverterBrand;

  num get panelWatt => _panelWatt;

  dynamic get lightBillImage => _lightBillImage;

  dynamic get passbookImage => _passbookImage;

  dynamic get panCardImage => _panCardImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['name'] = _name;
    map['mobile_number'] = _mobileNumber;
    map['panel_brand'] = _panelBrand;
    map['panel_quality'] = _panelQuality;
    map['inverter_brand'] = _inverterBrand;
    map['panel_watt'] = _panelWatt;
    map['light_bill_image'] = _lightBillImage;
    map['passbook_image'] = _passbookImage;
    map['pan_card_image'] = _panCardImage;
    return map;
  }
}
