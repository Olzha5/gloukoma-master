import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gloukoma/screens/account_screen.dart';
import 'package:gloukoma/screens/login_screen.dart';
import 'package:gloukoma/screens/reset_password_screen.dart';
import 'package:gloukoma/screens/signup_screen.dart';
import 'package:gloukoma/screens/verify_email_screen.dart';
import 'package:gloukoma/services/firebase_streem.dart';
import 'package:gloukoma/screens/home_screen.dart';
import 'package:gloukoma/screens/about_glaukoma_screen.dart';
import 'package:gloukoma/screens/Connect_screen.dart';
import 'package:gloukoma/screens/my_data_screen.dart';

// Firebase Авторизация - Сценарии:
//    Войти - Почта / Пароль
//    Личный кабинет
//    Зарегистрироваться - Почта / Пароль два раза
//        Подтвердить почту - Отправить письмо снова / Отменить
//    Сбросить пароль - Почта

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      routes: {
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/account': (context) => const AccountScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
        '/about_glaucoma':(context) => const About(),
        '/connect':(context) => Connect(),
        '/my_data':(context) => Mydata(),

      },
      initialRoute: '/home',
    );
  }
}
