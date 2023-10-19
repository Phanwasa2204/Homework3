import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/models/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<Album>? _albumList;
  String? _error;

  void getAlbums() async {
    try {
      setState(() {
        _error = null;
      });

      final response =
      await _dio.get('https://jsonplaceholder.typicode.com/albums');
      debugPrint(response.data.toString());

      List list = jsonDecode(response.data.toString());
      setState(() {
        _albumList = list.map((item) => Album.fromJson(item)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('Error: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_error != null) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              getAlbums();
            },
            child: const Text('RETRY'),
          )
        ],
      );
    } else if (_albumList == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = ListView.builder(
        itemCount: _albumList!.length,
        itemBuilder: (context, index) {
          var album = _albumList![index];
          return Card(
            child: ListTile(
              title: Text(album.title),
              subtitle: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.pink[100], // Set the background color for both Album ID and User ID to pink
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Album ID: ${album.id}'),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.cyan[100], // Set the background color to pink
                      borderRadius: BorderRadius.circular(8), // Optional: Add border radius for a rounded look
                    ),// 10-pixel gap

                    padding: const EdgeInsets.all(8.0),
                    child: Text('User ID: ${album.userId}'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(body: body);
  }
}