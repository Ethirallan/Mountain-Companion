class StopModel {
  String _location;
  int _height;
  String _time;

  StopModel(this._location, this._height, this._time);

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  int get height => _height;

  set height(int value) {
    _height = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }

  Map<String,dynamic> toJson(){
    return {
      'location': this._location,
      'height': this._height,
      'time': this._time,
    };
  }
}