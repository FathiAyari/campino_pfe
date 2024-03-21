import 'package:campino_pfe/presentation/Authentication/Sign_in/sign_in.dart';
import 'package:campino_pfe/presentation/Authentication/Sign_up/signup.dart';
import 'package:campino_pfe/presentation/Splash_screen/splashscreen.dart';
import 'package:campino_pfe/presentation/admin/admin_home_view.dart';
import 'package:campino_pfe/presentation/center_manager/manager_home_view.dart';
import 'package:campino_pfe/presentation/client/views/client_home_view.dart';
import 'package:campino_pfe/presentation/on_boarding/on_boarding_page.dart';
import 'package:flutter/material.dart';

class AppRouting {
  static final String splashScreen = "/";
  static final String login = "/login";
  static final String register = "/register";
  static final String onboarding = "/onboarding";
  static final String homeClient = "/home_client";
  static final String homeAdmin = "/home_admin";
  static final String homeManager = "/home_manager";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => SignupScreen());

      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnBoardingPage());
      case '/home_client':
        return MaterialPageRoute(builder: (_) => HomePageClient());
      case '/home_admin':
        return MaterialPageRoute(builder: (_) => AdmineHomeView());
      case '/home_manager':
        return MaterialPageRoute(builder: (_) => ManagerHomeView());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
