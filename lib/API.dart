import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:updateapimethod/workAPi.dart';

Future<updateapi> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );

  if (response.statusCode == 200) {

    return updateapi
        .fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {

    throw Exception('Failed to load album');
  }
}

Future<updateapi> updateAlbum(String title) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 200) {

    return updateapi
        .fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {

    throw Exception('Failed to update album.');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  late Future<updateapi> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Data Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Update Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: FutureBuilder<updateapi>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          snapshot.data!.userId.toString()),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          snapshot.data!.id.toString()),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                          snapshot.data!.title.toString()),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _controller,
                        decoration:InputDecoration(hintText: "Enter Title",hintStyle: TextStyle(fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)))
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureAlbum = updateAlbum(_controller.text);
                          });
                        },
                        child: const Text('Update Data'),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
