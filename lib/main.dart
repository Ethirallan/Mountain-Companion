import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mountaincompanion/pages/login/login_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeData(
          // brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.green,
          cursorColor: Colors.green,
        ),
        home: LoginPage(),
      ),
    );
  }
}