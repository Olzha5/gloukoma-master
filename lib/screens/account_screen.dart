import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_screen.dart';
import 'home_screen.dart';

import 'package:http/http.dart' as http;
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late Future<User> futureUser;

  Future<void> signOut() async {
    final navigator = Navigator.of(context);
    await FirebaseAuth.instance.signOut();
    navigator.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  int _selectedIndex = 2; // Профиль таңдалған

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Экрандар арасындағы ауысуды өңдеу
    if (index == 0) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } else if (index == 1) {
      // Чат экранын қосу
    } else if (index == 2) {
      // Ағымдағы экран - профиль, ештеңе жасамау
    }
  }

  Future<User> fetchUser() async {
    // Сіздің API шақыру логикаңыз осында болады
    //
    final user = FirebaseAuth.instance.currentUser;
    final response = await http.get(Uri.parse('http://olzhasna.beget.tech/api/get_top/${user?.email}/'));  // Замените на реальный URL

    if (response.statusCode == 200) {

      final jsonResponse = json.decode(response.body);
      var user = User.fromJson(jsonResponse['top'][0]);

      return user;
    } else {
      throw Exception('Failed to load users');
    }

    return User(
      displayName: 'Имя пользователя',
      phoneNumber: '+7 (000) 000-00-00',
      photoURL: 'https://example.com/default-avatar.png',
      score: 100,
    ); // Деректер қайтарылатын орын (мысалы)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () => signOut(),
          ),
        ],
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Қате: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var user = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        user.photoURL ?? 'https://example.com/default-avatar.png',
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName ?? 'Имя пользователя',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.phoneNumber ?? '+7 (000) 000-00-00',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ));
                      },
                    ),
                  ],
                ),
                Divider(height: 32),
                ListTile(
                  leading: Icon(Icons.card_giftcard, color: Colors.blue),
                  title: Text('Ұпай: ${user.score}'),
                  onTap: () {
                    // Нажатие әрекеті
                  },
                ),
                ListTile(
                  leading: Icon(Icons.ac_unit, color: Colors.blue),
                  title: Text('Заморозка'),
                  onTap: () {
                    // Нажатие әрекеті
                  },
                ),
                ListTile(
                  leading: Icon(Icons.language, color: Colors.blue),
                  title: Text('Тіл: Қазақ тілі'),
                  onTap: () {
                    // Нажатие әрекеті
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_outline, color: Colors.blue),
                  title: Text('Жиі қойылатын сұрақтар'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/connect');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.blue),
                  title: Text('Біз туралы'),
                  onTap: () {
                    Navigator.of(context).pushNamed('/about_glaucoma');
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => signOut(),
                    child: Text(
                      'Шығу',
                      style: TextStyle(color: Colors.pink, fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Ұпай табылмады'));
          }
        },
      ),
    );
  }
}

class User {
  final String? displayName;
  final String? phoneNumber;
  final String? photoURL;
  final int score;

  User({
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    required this.score,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      displayName: json['username'],
      phoneNumber: json['phoneNumber'],
      photoURL: json['photoURL'],
      score: json['total_score'],
    );
  }
}
