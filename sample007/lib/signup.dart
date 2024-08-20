import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    Future<void> signInWithGoogle() async {
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

        print(user);
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Signup Screen'),
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
                      signInWithGoogle();
                    },
                    child: const Text('Sign Up With Google'),
                  ),
                )
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

  // Future<void> fetchData() async {
  //   final url = Uri.parse(
  //     '${dotenv.env['API_URL']}/auth/signup',
  //   );
  //   print(url);
  //   try {
  //     final response = await http.post(url,
  //         body: jsonEncode({'email': email.text, 'password': password.text}),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         });

  //     if (response.statusCode == 200) {
  //       print('Response body: ${response.body}');
  //       String? rawCookie = response.headers['set-cookie'];
  //       if (rawCookie != null) {
  //         int index = rawCookie.indexOf('access_token=');
  //         if (index != -1) {
  //           int startIndex = index + 'access_token='.length;
  //           int endIndex = rawCookie.indexOf(';', startIndex);
  //           String accessToken = (endIndex == -1)
  //               ? rawCookie.substring(startIndex)
  //               : rawCookie.substring(startIndex, endIndex);
  //           print(accessToken);
  //         }
  //       }
  //     } else {
  //       print('Failed to load data');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  Future<void> fetchData() async {
    final url = Uri.parse(
      '${dotenv.env['API_URL']}/auth/signup',
    );
    print(url);
    try {
      final response = await http.post(url,
          body: jsonEncode({'email': email.text, 'password': password.text}),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        await storage.write(key: 'user_details', value: response.body);
        Navigator.pushNamed(context, '/');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User successfully registered!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('Failed to load data');
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
