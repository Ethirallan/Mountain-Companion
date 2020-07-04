import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

Response response;
Options options;
Dio dio = new Dio();


Future getWeatherMountains() async {
  Response response = await dio.get(
    'https://api.mountain-companion.com/weather/',
  );

  print(response.data);
  return response.data;
}