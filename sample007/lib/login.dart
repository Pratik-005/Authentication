import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final storage = FlutterSecureStorage();

    Future<void> signIn(user) async {
      final url = Uri.parse(
        '${dotenv.env['API_URL']}/auth/google',
      );

      final response = await http.post(url,
          body: jsonEncode({'email': user?.email, 'img': user?.photoURL}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        await storage.write(key: 'user_details', value: response.body);

        String? rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          int index = rawCookie.indexOf('access_token=');
          if (index != -1) {
            int startIndex = index + 'access_token='.length;
            int endIndex = rawCookie.indexOf(';', startIndex);
            String accessToken = (endIndex == -1)
                ? rawCookie.substring(startIndex)
                : rawCookie.substring(startIndex, endIndex);
            await storage.write(key: 'access_token', value: accessToken);
          }
        }
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User Not found  !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }

    Future<dynamic> signInWithGoogle() async {
      try {
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount!.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        return user;
      } catch (e) {
        print(e.toString());
      }
    }

    void signInWithGoogleAndContinue() async {
      try {
        final user = await signInWithGoogle();
        print(user);

        if (user != null) {
          await signIn(user);
        }
      } catch (e) {
        print('Error: ${e.toString()}');
      }
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Login Screen'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FormExample(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(320, 50),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      signInWithGoogleAndContinue();
                    },
                    child: const Text('Sign In With Google'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text("OR"),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text("Sign up"))),
              ],
            ))));
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});
  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();
  final storage = FlutterSecureStorage();

  Future<void> fetchData() async {
    final url = Uri.parse(
      '${dotenv.env['API_URL']}/auth/signin',
    );
    print(url);
    try {
      final response = await http.post(url,
          body: jsonEncode({'email': email.text, 'password': password.text}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        // String jsonUserDetails = jsonEncode(response.body);
        await storage.write(key: 'user_details', value: response.body);

        String? rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          int index = rawCookie.indexOf('access_token=');
          if (index != -1) {
            int startIndex = index + 'access_token='.length;
            int endIndex = rawCookie.indexOf(';', startIndex);
            String accessToken = (endIndex == -1)
                ? rawCookie.substring(startIndex)
                : rawCookie.substring(startIndex, endIndex);
            await storage.write(key: 'access_token', value: accessToken);
          }
        }
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User Not found  !'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: TextFormField(
              controller: email,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              validator: (String? value) {
                if (value == null ||
                    value.isEmpty ||
                    !value.endsWith("@gmail.com")) {
                  return 'Please enter valid email address';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: TextFormField(
              controller: password,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter valid password';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(320, 50),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  fetchData();
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
