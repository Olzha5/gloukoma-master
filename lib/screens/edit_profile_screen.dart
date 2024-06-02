import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  final user = FirebaseAuth.instance.currentUser;
  String? _selectedAvatarUrl;

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


  @override
  void initState() {
    super.initState();
    _name = user?.displayName;
    _selectedAvatarUrl = user?.photoURL ?? 'https://example.com/default-avatar.png';
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (user != null) {
        await user!.updateDisplayName(_name);
        await user!.updatePhotoURL(_selectedAvatarUrl);
        await user!.reload();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Профиль обновлен')));
        Navigator.pop(context); // Возвращаемся на предыдущий экран после сохранения
      }
    }
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
          ),
          itemCount: _avatars.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAvatarUrl = _avatars[index];
                });
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_avatars[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Параметрлер'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        _selectedAvatarUrl!,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showAvatarSelection,
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
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Атыңыз'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите имя';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Сақтау'),
              ),
              Spacer(),
              TextButton(
                onPressed: () async {
                  await user?.delete();
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
                },
                child: Text(
                  'Аккаунт жою',
                  style: TextStyle(color: Colors.pink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
