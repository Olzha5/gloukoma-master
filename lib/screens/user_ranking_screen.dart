import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String name;
  final int score;
  final String duration;
  final String avatarUrl;
  final int position;

  User({
    required this.name,
    required this.score,
    required this.duration,
    required this.avatarUrl,
    required this.position,
  });

  factory User.fromJson(Map<String, dynamic> json, int position) {
    return User(
      name: json['username'],
      score: json['total_score'] ?? 0,
      duration: '',  // Заполните это поле в зависимости от вашего API
      avatarUrl: 'https://example.com/default_avatar.png',  // Замените на реальный URL аватара
      position: position,
    );
  }
}

class UserRankingScreen extends StatefulWidget {
  const UserRankingScreen({Key? key}) : super(key: key);

  @override
  _UserRankingScreenState createState() => _UserRankingScreenState();
}

class _UserRankingScreenState extends State<UserRankingScreen> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    final user = FirebaseAuth.instance.currentUser;
    final response = await http.get(Uri.parse('http://olzhasna.beget.tech/api/get_top/${user?.email}/'));  // Замените на реальный URL

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<User> users = [];
      for (int i = 0; i < jsonResponse['top'].length; i++) {
        users.add(User.fromJson(jsonResponse['top'][i], i + 1));
      }
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Рейтинг пользователей'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки данных'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Нет данных для отображения'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${index + 1}.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10), // Отступ между номером и аватаром
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                      ],
                    ),
                    title: Text(
                      user.name,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      user.duration,
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      '${user.score} очков',
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      // Действие при нажатии на пользователя
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
