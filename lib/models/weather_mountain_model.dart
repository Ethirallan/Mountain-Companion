class WeatherMountainModel {
  int _id;
  String _location;
  String _datetime;
  String _icon;
  String _description;
  int _t;
  String _windIcon;
  int _windSpeed;
  int _windMaxSpeed;
  int _p;
  String _pTendency;
  int _rain;
  String _timestamp;

  WeatherMountainModel(
      this._id,
      this._location,
      this._datetime,
      this._icon,
      this._description,
      this._t,
      this._windIcon,
      this._windSpeed,
      this._windMaxSpeed,
      this._p,
      this._pTendency,
      this._rain,
      this._timestamp);

  String get timestamp => _timestamp;

  set timestamp(String value) {
    _timestamp = value;
  }

  int get rain => _rain;

  set rain(int value) {
    _rain = value;
  }

  String get pTendency => _pTendency;

  set pTendency(String value) {
    _pTendency = value;
  }

  int get p => _p;

  set p(int value) {
    _p = value;
  }

  int get windMaxSpeed => _windMaxSpeed;

  set windMaxSpeed(int value) {
    _windMaxSpeed = value;
  }

  int get windSpeed => _windSpeed;

  set windSpeed(int value) {
    _windSpeed = value;
  }

  String get windIcon => _windIcon;

  set windIcon(String value) {
    _windIcon = value;
  }

  int get t => _t;

  set t(int value) {
    _t = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get icon => _icon;

  set icon(String value) {
    _icon = value;
  }

  String get datetime => _datetime;

  set datetime(String value) {
    _datetime = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}