import 'package:e_commerceapp/controller/auth/auth_cubit.dart';
import 'package:e_commerceapp/helpers/shared_prefs_helper.dart';
import 'package:e_commerceapp/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<Splashscreen> {
  final SharedPrefsHelper _sharedPrefsHelper = SharedPrefsHelper();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await _sharedPrefsHelper.getIsLoggedIn();
    print("token: $token");
    if (token != null && token.isNotEmpty) {
      context.read<AuthCubit>().profile(token: token);
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Checking status...",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 176, 93, 93),
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              color: Color.fromARGB(255, 176, 93, 93),
            ),
          ],
        ),
      ),
    );
  }
}
