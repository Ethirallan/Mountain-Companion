import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

Response response;
Options options;
Dio dio = new Dio();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future login(String token) async {
  dio.options.headers["authorization"] = "Bearer $token";

  Response response = await dio.get(
    'https://api.mountain-companion.com/auth/login',

  );
  print(response.data.toString());
}

Future register(String token) async {
  FirebaseUser user = await _auth.currentUser();
  print(user.providerData);

  dio.options.headers["authorization"] = "Bearer $token";

  Response response = await dio.post(
    'https://api.mountain-companion.com/auth/register',
    data: {
      "uid": user.uid,
      "username": user.displayName,
      "email": user.email,
    }
  );
  print(response.data.toString());
}
