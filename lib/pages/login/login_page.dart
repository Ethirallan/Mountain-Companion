import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mountaincompanion/pages/travels/travels_page.dart';

class LoginPage extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _login(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (data.name != 'admin@admin.si') {
        return "User doesn't exist";
      }
      if (data.password != 'admin') {
        return 'Incorrect password!';
      }
      return null;
    });
  }

  Future<String> _register(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (name != 'admin@admin.si') {
        return "User doesn't exist";
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      theme: LoginTheme(
        primaryColor: Colors.green,
        pageColorLight: Colors.green,
        titleStyle: TextStyle(
          fontSize: 38,
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.purple.withOpacity(.1),
          contentPadding: EdgeInsets.zero,
        ),
      ),
      title: 'Mountain Companion',
      logo: 'assets/mc-logo.png',
      onLogin: _login,
      onSignup: _register,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => TravelsPage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}