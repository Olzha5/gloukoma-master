import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
final List<String> _avatars = [
  'https://flyclipart.com/thumbs/med-boukrima-specialist-webmaster-php-e-commerce-web-developer-coder-avatar-1054388.png',
  'https://yt3.ggpht.com/ytc/AKedOLQXIYjywJ9JwfQy-HPL84TxpEJAhqLQOjq7lMwV=s900-c-k-c0x00ffffff-no-rj',
  'https://avatars.mds.yandex.net/i?id=23014985e9072d06ffde7fc691d6284bf55b77d2-9068519-images-thumbs&ref=rim&n=33&w=252&h=252',
  'https://avatars.mds.yandex.net/i?id=5d03c304b337838db89a609969f60a6ca47d1f95-10512135-images-thumbs&ref=rim&n=33&w=252&h=252',
  'https://avatars.mds.yandex.net/i?id=99774e884d870164659d37aac1468c07c7bd0a67-10933600-images-thumbs&ref=rim&n=33&w=252&h=252',
  'https://avatars.mds.yandex.net/i?id=204fedfc91f56eaf57a5899b478e58ec5d69d18e-8268761-images-thumbs&ref=rim&n=33&w=252&h=252',
  'https://avatars.mds.yandex.net/i?id=b6e446a4a74291d13d573b4890176f6b5d8665b6-8519693-images-thumbs&ref=rim&n=33&w=252&h=252',
  'https://avatars.mds.yandex.net/i?id=2c23c5f676a1f240c0abd5b405fdd73a-5408886-images-thumbs&ref=rim&n=33&w=252&h=252',
  'https://avatars.mds.yandex.net/i?id=dd2c8a5dcac85435bf246ef6df8732a952c92859-10544851-images-thumbs&ref=rim&n=33&w=252&h=252',
  'https://avatars.mds.yandex.net/i?id=7932e342929c4ccac2ce0c968ba59dc17a2b1d15-9380132-images-thumbs&ref=rim&n=33&w=252&h=252',
  'https://avatars.mds.yandex.net/i?id=6b3a690703cc80e7e02e796aea4a56fd986c16fe-9053088-images-thumbs&ref=rim&n=33&w=252&h=252',
  'https://avatars.mds.yandex.net/i?id=e49d456994ade07a0bcd3f52e01489479994e20a-8312020-images-thumbs&ref=rim&n=33&w=252&h=252',
];
Future<List<User>> fetchUsers({top = true}) async {
  final user = FirebaseAuth.instance.currentUser;
  final response = await http.get(Uri.parse('http://olzhasna.beget.tech/api/get_top/${user?.email}/'));  // Замените на реальный URL

  if (response.statusCode == 200) {

    final jsonResponse = json.decode(response.body);
    List<User> users = [];
    for (int i = 0; i < jsonResponse[(top)? 'top' : 'score'].length; i++) {
      users.add(User.fromJson(jsonResponse[(top)? 'top' : 'score'][i], i + 1));
    }
    return users;
  } else {
    throw Exception('Failed to load users');
  }
}

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
      avatarUrl:  _avatars[ position % _avatars.length],  // Замените на реальный URL аватара
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
