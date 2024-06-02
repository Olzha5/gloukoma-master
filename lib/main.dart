import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gloukoma/screens/account_screen.dart';
import 'package:gloukoma/screens/home_screen.dart';
import 'package:gloukoma/screens/login_screen.dart';
import 'package:gloukoma/screens/reset_password_screen.dart';
import 'package:gloukoma/screens/signup_screen.dart';
import 'package:gloukoma/screens/verify_email_screen.dart';
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
        '/': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
        '/about_glaucoma': (context) => const About(),
        '/connect': (context) => Connect(),
        '/my_data': (context) => Mydata(),
      },
      initialRoute: '/',
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    PlaceholderWidget('Чат'), // Здесь вы можете заменить PlaceholderWidget на ваш экран чата
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Оқу',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.smartphone),
          //   label: 'Курс',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Чат',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String text;

  const PlaceholderWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
