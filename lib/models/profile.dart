import 'package:demo_flutter/models/post.dart';
import 'package:flutter/material.dart';

class Profile {
  final String fullName;
  final CircleAvatar avatar;
  DateTime birthday;
  int? age;
  List<Post> posts;

  Profile(
      {required this.fullName,
      required this.avatar,
      required this.birthday,
      required this.posts}) {
    age = calculateAge(birthday);
  }

  int calculateAge(DateTime birthday) {
    final now = DateTime.now();
    final age = now.year - birthday.year;
    final birthdayThisYear = DateTime(now.year, birthday.month, birthday.day);
    return now.isBefore(birthdayThisYear) ? age - 1 : age;
  }

  setBirthday(DateTime newBirthday) {
    birthday = newBirthday;
    age = calculateAge(newBirthday);
  }

  addPost(Post post) {
    posts.add(post);
  }
}
