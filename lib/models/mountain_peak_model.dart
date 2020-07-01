class MountainPeakModel {
  int _id;
  String _name;
  String _lat;
  String _lng;
  int _height;
  DateTime _created;

  MountainPeakModel(
      this._id, this._name, this._lat, this._lng, this._height, this._created);

  DateTime get created => _created;

  set created(DateTime value) {
    _created = value;
  }

  int get height => _height;

  set height(int value) {
    _height = value;
  }

  String get lng => _lng;

  set lng(String value) {
    _lng = value;
  }

  String get lat => _lat;

  set lat(String value) {
    _lat = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}