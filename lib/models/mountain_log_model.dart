class MountainLogModel {
  int _id;
  String _userId;
  int _peakId;
  DateTime _date;
  DateTime _timestamp;

  MountainLogModel(
      this._id, this._userId, this._peakId, this._date, this._timestamp);

  DateTime get timestamp => _timestamp;

  set timestamp(DateTime value) {
    _timestamp = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  int get peakId => _peakId;

  set peakId(int value) {
    _peakId = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}