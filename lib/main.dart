import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: _count,
            itemBuilder: (BuildContext context, int i) {
              final post = _postsJson[i];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.horizontal,
                onDismissed: (_) {
                  setState(() {
                    _postsJson.removeAt(i);
                    _count--;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                      onPressed: launchWebBrowser,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.teal),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      child: Text(
                        "${post["login"]}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 23, color: Colors.white),
                      )),
                ),
              );
            }));
  }

  // android
  void launchWebBrowser() async {
    const url = "https://github.com/Ilya193";
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  var _count = 0;

  final _url = "https://api.github.com/users";
  var _postsJson = [];

  void fetchPosts() async {
    try {
      final response = await get(Uri.parse(_url));
      final jsonData = jsonDecode(response.body) as List;

      setState(() {
        _postsJson = jsonData;
        _count = jsonData.length;
      });
    } catch (err) {}
  }
}
