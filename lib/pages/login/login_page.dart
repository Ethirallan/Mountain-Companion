import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mountaincompanion/api/auth.dart';
import 'package:mountaincompanion/pages/travels/travels_page.dart';

class LoginPage extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 2250);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _login(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      try {
        AuthResult result  = (await _auth.signInWithEmailAndPassword(
          email: data.name,
          password: data.password,
        ));

        FirebaseUser user = result.user;

        IdTokenResult token = await user.getIdToken();
        print(token.token);
        // connect to backend
        await login(token.token);

        return null;

      } on PlatformException catch (e) {
        print(e);
        return e.code;
      }
    });
  }

  Future<String> _register(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
        email: data.name,
        password: data.password,
      ))
      .user;
      IdTokenResult token = await user.getIdToken();
      await register(token.token);
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
        pageColorLight: Colors.lightGreenAccent,
        pageColorDark: Colors.lightBlueAccent,
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