import 'dart:async';

import 'package:demo_flutter/models/post.dart';
import 'package:demo_flutter/models/profile.dart';
import 'package:flutter/material.dart';

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
