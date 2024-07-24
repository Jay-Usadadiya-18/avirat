/// id : 1
/// code : 34433221111111
/// description : ""
/// username : "badalbhai"

class Barcodegettt {
  Barcodegettt({
    required this.id,
    required this.code,
    required this.description,
    required this.username,
  });

  Barcodegettt.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        code = json['code'],
        description = json['description'],
        username = json['username'];

  num id;
  num code;
  String description;
  String username;

  Barcodegettt copyWith({
    num? id,
    num? code,
    String? description,
    String? username,
  }) =>
      Barcodegettt(
        id: id ?? this.id,
        code: code ?? this.code,
        description: description ?? this.description,
        username: username ?? this.username,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['code'] = code;
    map['description'] = description;
    map['username'] = username;
    return map;
  }
}
