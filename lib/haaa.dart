class Haaa {
  Haaa({
    required this.id,
    required this.username,
    required this.transportName,
    required this.nameD,
    required this.panelBrand,
    required this.size404053,
    required this.size40406,
    required this.size60406,
    required this.pvcPipe,
    required this.ekit,
    required this.bfc,
    required this.boxKit,
  });

  Haaa.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        transportName = json['transport_name'],
        nameD = json['name_d'],
        panelBrand = json['panel_brand'],
        size404053 = json['size_40_40_53'],
        size40406 = json['size_40_40_6'],
        size60406 = json['size_60_40_6'],
        pvcPipe = json['pvc_pipe'],
        ekit = json['ekit'],
        bfc = json['bfc'],
        boxKit = json['box_kit'];

  num? id;
  String? username;
  String? transportName;
  String? nameD;
  String? panelBrand;
  num? size404053;
  num? size40406;
  num? size60406;
  num? pvcPipe;
  num? ekit;
  num? bfc;
  num? boxKit;

  Haaa copyWith({
    num? id,
    String? username,
    String? transportName,
    String? nameD,
    String? panelBrand,
    num? size404053,
    num? size40406,
    num? size60406,
    num? pvcPipe,
    num? ekit,
    num? bfc,
    num? boxKit,
  }) =>
      Haaa(
        id: id ?? this.id,
        username: username ?? this.username,
        transportName: transportName ?? this.transportName,
        nameD: nameD ?? this.nameD,
        panelBrand: panelBrand ?? this.panelBrand,
        size404053: size404053 ?? this.size404053,
        size40406: size40406 ?? this.size40406,
        size60406: size60406 ?? this.size60406,
        pvcPipe: pvcPipe ?? this.pvcPipe,
        ekit: ekit ?? this.ekit,
        bfc: bfc ?? this.bfc,
        boxKit: boxKit ?? this.boxKit,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['transport_name'] = transportName;
    map['name_d'] = nameD;
    map['panel_brand'] = panelBrand;
    map['size_40_40_53'] = size404053;
    map['size_40_40_6'] = size40406;
    map['size_60_40_6'] = size60406;
    map['pvc_pipe'] = pvcPipe;
    map['ekit'] = ekit;
    map['bfc'] = bfc;
    map['box_kit'] = boxKit;
    return map;
  }
}
