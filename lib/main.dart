import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
              foregroundImage: NetworkImage(
                'https://sun9-79.userapi.com/impf/c858332/v858332531/4acac/NycU-LcHZXo.jpg?size=810x1080&quality=96&sign=aeeb8f2710ae7df0318fee0430cd76c6&type=album',
              ),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  State<MyHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MyHomePage> {
  Future<void> selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDatePickerMode: DatePickerMode.year,
        initialDate: DateTime(2000, 1, 1),
        firstDate: DateTime(1900, 1, 1),
        lastDate: DateTime.now(),
        helpText: 'Choose new birthday');
    if (selectedDate != null && selectedDate != widget.profile.birthday) {
      setState(() {
        widget.profile.setBirthday(selectedDate);
      });
    }
  }

  void addPost() {
    String? tmpTitle;
    String? tmpText;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text(
                'Create new post',
                textAlign: TextAlign.center,
              ),
              content: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 300, maxWidth: 350),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IntrinsicHeight(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 100),
                          child: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.multiline,
                            expands: true,
                            maxLines: null,
                            maxLength: 100,
                            onChanged: (String? value) => tmpTitle = value,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.title), labelText: 'Title*'),
                          ),
                        ),
                      ),
                      IntrinsicHeight(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.multiline,
                            expands: true,
                            maxLines: null,
                            maxLength: 3000,
                            onChanged: (String? value) => tmpText = value,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.edit),
                                labelText: 'Post text*'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() => tmpTitle == null || tmpText == null
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        title: Text(
                                            'Title or text of new post is empty'),
                                      );
                                    })
                                : widget.profile.addPost(
                                    Post(title: tmpTitle!, text: tmpText!)));
                            Navigator.pop(context);
                          },
                          child: const Text('Post')),
                    ],
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          toolbarHeight: MediaQuery.of(context).size.height > 400
              ? 100
              : MediaQuery.of(context).size.height / 4,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(widget.profile.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => selectDate(context),
                child: Text(
                  '${widget.profile.age} лет',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      shadows: <Shadow>[
                        Shadow(color: Colors.yellow, blurRadius: 4)
                      ]),
                ),
              )
            ],
          )),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: ListView(children: [
          DrawerHeader(
            child: widget.profile.avatar,
          ),
          const Text('Main page',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('Messaging',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('Settings',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('About',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
        ]),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.tealAccent, style: BorderStyle.solid, width: 4),
            borderRadius: BorderRadius.circular(10.0),
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topLeft,
              stops: [
                0.05,
                0.45,
                0.75,
              ],
              colors: [
                Colors.red,
                Colors.indigo,
                Colors.teal,
              ],
            )),
        child: ListView(
          children: widget.profile.posts
              .map((post) => ColoredBox(
                    color: Colors.transparent,
                    child: Table(
                      border: const TableBorder(
                          bottom: BorderSide(width: 2, color: Colors.black26)),
                      columnWidths: Map.of({0: const FlexColumnWidth(2)}),
                      children: [
                        TableRow(children: [
                          Column(
                            children: [
                              Text(
                                post.title,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(post.text,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                post.likes.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: <Shadow>[
                                      Shadow(color: Colors.white, blurRadius: 2)
                                    ]),
                              ),
                              RawMaterialButton(
                                  shape: const CircleBorder(),
                                  onPressed: () => setState(() => post.likes++),
                                  child: const Icon(
                                    Icons.thumb_up,
                                    color: Colors.white,
                                    size: 22,
                                  ))
                            ],
                          ),
                        ])
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => addPost(),
        tooltip: 'Add post',
        child: const Icon(Icons.add),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }
}

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

class Post {
  int likes = 0;
  final String text;
  final String title;

  Post({required this.title, required this.text});
}
