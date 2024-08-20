import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 191, 229, 220),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Profile Page'),
      ),
      body: ProfilePage(),
    );
  }
}

// class User {
//   final String name;
//   final String email;
//   final String profileImg;

//   User(this.name, this.email, this.profileImg);

//   User.fromJson(Map<String, dynamic> json)
//       : name = json['name'] as String,
//         email = json['email'] as String,
//         profileImg = json['profileImg'] as String;

//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'email': email,
//         'profileImg': profileImg,
//       };
// }

class User {
  final String email;
  final String img;
  // final String name;

  User({
    required this.email,
    required this.img,
    // required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      img: json['img'] as String,
      // name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'img': img,
        // 'name': name,
      };
}

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = FlutterSecureStorage();

  User? storedData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final jsonUserDetails = await storage.read(key: 'user_details');

      print('Stored JSON: $jsonUserDetails');

      final decodedData = jsonDecode(jsonUserDetails!);

      final user = User.fromJson(decodedData);
      setState(() {
        storedData = user;
      });

      print("...........................................");
      print(storedData?.email);
    } catch (e) {
      print('Error reading data: $e');
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await storage.delete(key: 'user_details');
      await storage.delete(key: 'access_token');
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      print('Error during logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('${storedData?.img}'),
            ),
            SizedBox(height: 20),
            SizedBox(height: 10),
            Text(
              '${storedData?.email}',
              style: TextStyle(
                fontSize: 16,
                color: const Color.fromARGB(255, 80, 51, 51),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await _logout(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 15, 14, 14),
                  foregroundColor: Colors.amber),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
