class StopModel {
  int _id;
  int _travelId;
  String _location;
  int _height;
  String _time;

  StopModel(this._location, this._height, this._time);


  StopModel.withID(this._id, this._travelId, this._location, this._height, this._time);


  int get id => _id;

  set id(int value) {
    _id = value;
  }

  int get travelId => _travelId;

  set travelId(int value) {
    _travelId = value;
  }

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
      'id': this._id,
      'travel_id': this._travelId,
      'location': this._location,
      'height': this._height,
      'time': this._time,
    };
  }
}