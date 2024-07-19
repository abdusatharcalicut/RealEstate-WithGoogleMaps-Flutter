import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:publrealty/screens/authentication/login_screen.dart';
import 'package:publrealty/screens/authentication/register_screen.dart';

class AuthenticationRootScreen extends StatelessWidget {
  AuthenticationRootScreen({Key? key}) : super(key: key);

  final _navigatorKey = GlobalKey();

  static void navigate(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AuthenticationRootScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;

          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => const LoginScreen();
              break;
            case '/register':
              builder = (BuildContext context) => const RegisterScreen();
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }

          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
        },
      ),
    );
  }
}
