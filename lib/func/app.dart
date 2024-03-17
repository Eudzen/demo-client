import 'package:demo_flutter/UI/homepage.dart';
import 'package:demo_flutter/models/post.dart';
import 'package:demo_flutter/models/profile.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade600),
        useMaterial3: true,
      ),
      home: MyHomePage(
        profile: Profile(
            fullName: 'Orlov Eugene',
            avatar: const CircleAvatar(
              maxRadius: 35,
              minRadius: 10,
              foregroundImage: AssetImage('assets/me.jpg'),
            ),
            birthday: DateTime(1998, 6, 16),
            posts: <Post>[
              Post(
                  title: 'Первый пост',
                  text:
                      'Backend java spring, postgres, hibernate, jpa, docker'),
              Post(title: 'Второй пост', text: 'k8s, git, mvc, microservices'),
            ]),
      ),
    );
  }
}
