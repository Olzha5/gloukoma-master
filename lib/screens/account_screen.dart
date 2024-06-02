
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_screen.dart';
import 'home_screen.dart'; // Импортируйте HomeScreen


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> signOut() async {
    final navigator = Navigator.of(context);

    await FirebaseAuth.instance.signOut();


    navigator.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

  }

  int _selectedIndex = 2; // Профиль выбран

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Обработка перехода между экранами
    if (index == 0) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } else if (index == 1) {
      // Добавьте экран для чата
    } else if (index == 2) {
      // Текущий экран - профиль, ничего не делать
    }

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

      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  user?.photoURL ?? 'https://example.com/default-avatar.png',
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
                    user?.displayName ?? 'Имя пользователя',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.phoneNumber ?? '+7 (000) 000-00-00',
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
            title: Text('Ұпай'),
            onTap: () {
              // Действие на нажатие
            },
          ),
          ListTile(
            leading: Icon(Icons.ac_unit, color: Colors.blue),
            title: Text('Заморозка'),
            onTap: () {
              // Действие на нажатие
            },
          ),
          ListTile(
            leading: Icon(Icons.language, color: Colors.blue),
            title: Text('Тіл: Қазақ тілі'),
            onTap: () {
              // Действие на нажатие
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

      ),
    );
  }
}
