/// id : 1
/// code : 34433221111111
/// description : ""
/// username : "badalbhai"

class Barcodegettt {
  Barcodegettt({
    num id,
    num code,
    String description,
    String username,
  }) {
    _id = id;
    _code = code;
    _description = description;
    _username = username;
  }

  Barcodegettt.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _description = json['description'];
    _username = json['username'];
  }

  num _id;
  num _code;
  String _description;
  String _username;

  Barcodegettt copyWith({
    num id,
    num code,
    String description,
    String username,
  }) =>
      Barcodegettt(
        id: id ?? _id,
        code: code ?? _code,
        description: description ?? _description,
        username: username ?? _username,
      );

  num get id => _id;

  num get code => _code;

  String get description => _description;

  String get username => _username;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['description'] = _description;
    map['username'] = _username;
    return map;
  }
}
