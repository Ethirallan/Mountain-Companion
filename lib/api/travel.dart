import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

Response response;
Options options;
Dio dio = new Dio();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future createNewTravel(Map<String, Object> data) async {
  FirebaseUser user = await _auth.currentUser();

  IdTokenResult token = await user.getIdToken();
  dio.options.headers["authorization"] = "Bearer ${token.token}";


  Response response = await dio.post(
      'https://api.mountain-companion.com/travels',
      data: data
  );
}

Future getTravels() async {
  FirebaseUser user = await _auth.currentUser();

  IdTokenResult token = await user.getIdToken();
  dio.options.headers["authorization"] = "Bearer ${token.token}";


  Response response = await dio.get(
    'https://api.mountain-companion.com/travels',
  );

  //print(response.data);
  return response.data;
}

Future deleteTravel(int id) async {
  FirebaseUser user = await _auth.currentUser();

  IdTokenResult token = await user.getIdToken();
  dio.options.headers["authorization"] = "Bearer ${token.token}";


  Response response = await dio.delete(
    'https://api.mountain-companion.com/travels/$id',
  );

  print(response.data);
  return response.data;
}

Future getStops(int id) async {
  FirebaseUser user = await _auth.currentUser();

  IdTokenResult token = await user.getIdToken();
  dio.options.headers["authorization"] = "Bearer ${token.token}";


  Response response = await dio.get(
    'https://api.mountain-companion.com/stops/$id',
  );

  //print(response.data);
  return response.data;
}

Future getImages(int id) async {
  FirebaseUser user = await _auth.currentUser();

  IdTokenResult token = await user.getIdToken();
  dio.options.headers["authorization"] = "Bearer ${token.token}";


  Response response = await dio.get(
    'https://api.mountain-companion.com/travel-images/$id',
  );

  //print(response.data);
  return response.data;
}