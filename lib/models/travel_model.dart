class TravelModel {
  int _id;
  String _userId;
  String _title;
  DateTime _date;
  String _notes;
  String _thumbnail;
  String _thumbnailBlurhash;
  bool _public;
  DateTime _created;

  TravelModel(this._id, this._userId, this._title, this._date, this._notes,
      this._thumbnail,this._thumbnailBlurhash, this._public, this._created);

  DateTime get created => _created;

  set created(DateTime value) {
    _created = value;
  }

  bool get public => _public;

  set public(bool value) {
    _public = value;
  }

  String get thumbnailBlurhash => _thumbnailBlurhash;

  set thumbnailBlurhash(String value) {
    _thumbnailBlurhash = value;
  }

  String get thumbnail => _thumbnail;

  set thumbnail(String value) {
    _thumbnail = value;
  }

  String get notes => _notes;

  set notes(String value) {
    _notes = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
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