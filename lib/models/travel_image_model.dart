class TravelImageModel {
  int _id;
  int _travelId;
  String _url;
  String _blurhash;

  TravelImageModel(this._id, this._travelId, this._url, this._blurhash);

  String get blurhash => _blurhash;

  set blurhash(String value) {
    _blurhash = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  int get travelId => _travelId;

  set travelId(int value) {
    _travelId = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}