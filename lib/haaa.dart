/// id : 1
/// username : "bhargavbhai"
/// transport_name : "bhargav bhai"
/// name_d : "koi nai"
/// panel_brand : "Adani"
/// size_40_40_53 : 1
/// size_40_40_6 : 1
/// size_60_40_6 : 1
/// pvc_pipe : 1
/// ekit : 1
/// bfc : 4
/// box_kit : 2

class Haaa {
  Haaa({
    num id,
    String username,
    String transportName,
    String nameD,
    String panelBrand,
    num size404053,
    num size40406,
    num size60406,
    num pvcPipe,
    num ekit,
    num bfc,
    num boxKit,
  }) {
    _id = id;
    _username = username;
    _transportName = transportName;
    _nameD = nameD;
    _panelBrand = panelBrand;
    _size404053 = size404053;
    _size40406 = size40406;
    _size60406 = size60406;
    _pvcPipe = pvcPipe;
    _ekit = ekit;
    _bfc = bfc;
    _boxKit = boxKit;
  }

  Haaa.fromJson(dynamic json) {
    _id = json['id'];
    _username = json['username'];
    _transportName = json['transport_name'];
    _nameD = json['name_d'];
    _panelBrand = json['panel_brand'];
    _size404053 = json['size_40_40_53'];
    _size40406 = json['size_40_40_6'];
    _size60406 = json['size_60_40_6'];
    _pvcPipe = json['pvc_pipe'];
    _ekit = json['ekit'];
    _bfc = json['bfc'];
    _boxKit = json['box_kit'];
  }

  num _id;
  String _username;
  String _transportName;
  String _nameD;
  String _panelBrand;
  num _size404053;
  num _size40406;
  num _size60406;
  num _pvcPipe;
  num _ekit;
  num _bfc;
  num _boxKit;

  Haaa copyWith({
    num id,
    String username,
    String transportName,
    String nameD,
    String panelBrand,
    num size404053,
    num size40406,
    num size60406,
    num pvcPipe,
    num ekit,
    num bfc,
    num boxKit,
  }) =>
      Haaa(
        id: id ?? _id,
        username: username ?? _username,
        transportName: transportName ?? _transportName,
        nameD: nameD ?? _nameD,
        panelBrand: panelBrand ?? _panelBrand,
        size404053: size404053 ?? _size404053,
        size40406: size40406 ?? _size40406,
        size60406: size60406 ?? _size60406,
        pvcPipe: pvcPipe ?? _pvcPipe,
        ekit: ekit ?? _ekit,
        bfc: bfc ?? _bfc,
        boxKit: boxKit ?? _boxKit,
      );

  num get id => _id;

  String get username => _username;

  String get transportName => _transportName;

  String get nameD => _nameD;

  String get panelBrand => _panelBrand;

  num get size404053 => _size404053;

  num get size40406 => _size40406;

  num get size60406 => _size60406;

  num get pvcPipe => _pvcPipe;

  num get ekit => _ekit;

  num get bfc => _bfc;

  num get boxKit => _boxKit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['username'] = _username;
    map['transport_name'] = _transportName;
    map['name_d'] = _nameD;
    map['panel_brand'] = _panelBrand;
    map['size_40_40_53'] = _size404053;
    map['size_40_40_6'] = _size40406;
    map['size_60_40_6'] = _size60406;
    map['pvc_pipe'] = _pvcPipe;
    map['ekit'] = _ekit;
    map['bfc'] = _bfc;
    map['box_kit'] = _boxKit;
    return map;
  }
}
