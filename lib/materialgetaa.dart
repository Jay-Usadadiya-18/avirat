class Materialgetaa {
  Materialgetaa({
    this.id,
    this.something1,
    this.something2,
    this.something3,
    this.picPipe,
    this.basePlate,
    this.autoRoad,
    this.pcCable,
    this.acCable,
    this.laCable,
    this.username,
    this.nameM,
  });

  Materialgetaa.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        something1 = json['_40_40_53'],
        something2 = json['_40_40_6'],
        something3 = json['_60_40_6'],
        picPipe = json['pic_pipe'],
        basePlate = json['base_plate'],
        autoRoad = json['auto_road'],
        pcCable = json['pc_cable'],
        acCable = json['ac_cable'],
        laCable = json['la_cable'],
        username = json['username'],
        nameM = json['name_m'];

  num? id;
  num? something1;
  num? something2;
  num? something3;
  num? picPipe;
  num? basePlate;
  num? autoRoad;
  num? pcCable;
  num? acCable;
  num? laCable;
  String? username;
  String? nameM;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['_40_40_53'] = something1;
    data['_40_40_6'] = something2;
    data['_60_40_6'] = something3;
    data['pic_pipe'] = picPipe;
    data['base_plate'] = basePlate;
    data['auto_road'] = autoRoad;
    data['pc_cable'] = pcCable;
    data['ac_cable'] = acCable;
    data['la_cable'] = laCable;
    data['username'] = username;
    data['name_m'] = nameM;
    return data;
  }
}
