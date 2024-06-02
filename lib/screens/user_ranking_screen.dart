import 'package:flutter/material.dart';

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
}

class UserRankingScreen extends StatefulWidget {
  const UserRankingScreen({Key? key}) : super(key: key);
  @override
  _UserRankingScreenState createState() => _UserRankingScreenState();
}

class _UserRankingScreenState extends State<UserRankingScreen> {
  final List<User> users = [
    User(
      name: 'toshan',
      score: 111,
      duration: 'больше 1 года',
      avatarUrl: 'https://example.com/avatar1.png',
      position: 1,
    ),
    User(
      name: 'анель',
      score: 92,
      duration: '',
      avatarUrl: 'https://example.com/avatar2.png',
      position: 2,
    ),
    User(
      name: 'Arya',
      score: 80,
      duration: '',
      avatarUrl: 'https://example.com/avatar3.png',
      position: 3,
    ),
    User(
      name: 'Sana',
      score: 68,
      duration: '',
      avatarUrl: 'https://example.com/avatar4.png',
      position: 4,
    ),
    User(
      name: 'Nurgali',
      score: 47,
      duration: 'больше 1 года',
      avatarUrl: 'https://example.com/avatar5.png',
      position: 5,
    ),
    User(
      name: 'Диана',
      score: 45,
      duration: '',
      avatarUrl: 'https://example.com/avatar6.png',
      position: 6,
    ),
    User(
      name: 'Елена',
      score: 40,
      duration: '2 часа',
      avatarUrl: 'https://example.com/avatar7.png',
      position: 7,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Рейтинг пользователей'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatarUrl),
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
      ),
    );
  }
}
