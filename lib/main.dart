import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MaterialApp(
      home: FirstScreen(),
    ),
  );
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class User {
  int id;
  String name;
  String email;
  String gender;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.gender});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        gender: json['gender']);
  }
}

class _FirstScreenState extends State<FirstScreen> {
  final String apiUrl = "https://gorest.co.in/public/v1/users";

  Future<List<User>> fetchUsers() async {
    var response = await http.get(Uri.parse(apiUrl));
    return (json.decode(response.body)['data'] as List)
        .map((e) => User.fromJson(e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('First Screen'),
        ),
        body: Container(
          color: Colors.grey,
          padding: const EdgeInsets.all(8),
          child: FutureBuilder<List<User>>(
            future: fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<User> users = snapshot.data as List<User>;
                return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Text(users[index].name),
                              Text(users[index].email),
                              Text(users[index].gender),
                            ],
                          ),
                        ),
                      );
                    });
              }
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text('error');
              }
              return CircularProgressIndicator();
            },
          ),
        ));
  }
}
