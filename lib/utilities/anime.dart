class Anime {
  late int _id;
  late String aTitleNative;
  late String aTitleRomanji;
  Anime(this._id, this.aTitleNative, this.aTitleRomanji);

  int get id => _id;

  // Anime object mapping
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['aTitleNative'] = aTitleNative;
    map['aTitleRomanji'] = aTitleRomanji;
    return map;
  }

  // extract Anime from map
  Anime.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    aTitleNative = map['aTitleNative'];
    aTitleRomanji = map['aTitleRomanji'];
  }
}
