import 'package:e_commerceapp/screens/auth/login.dart';
import 'package:e_commerceapp/screens/auth/register.dart';
import 'package:e_commerceapp/screens/auth/splashScreen.dart';
import 'package:e_commerceapp/screens/home/home_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String splashScreen = '/splashScreen';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => Register());
      case splashScreen:
        return MaterialPageRoute(builder: (_) => Splashscreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      default:
        return MaterialPageRoute(
          builder: (_) => defualtpage(),
        );
    }
  }
}

class defualtpage extends StatelessWidget {
  const defualtpage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('No route defined for this name')),
    );
  }
}
