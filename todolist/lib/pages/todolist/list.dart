import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '/conf/config.dart';
import '/pages/todolist/edit.dart';
import '/pages/todolist/add.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  Future<dynamic> getTodoList() async {
    var url = Uri.parse(APIRoutes['todo-list']!);
    //var headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final response = await http.get(url); //, headers: headers);
    if (response.statusCode == 200) {
      var result = utf8.decode(response.bodyBytes);
      return jsonDecode(result);
    } else {
      return [];
    }
    /*return [
      {"id": 7, "title": "ทดสอบ", "detail": "สวัสด่ีครับ"},
      {"id": 8, "title": "ประชุมที่กทม", "detail": "ประชุมเรื่องอะไรไม่รู้"},
    ];*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('todolist'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var route = MaterialPageRoute(builder: (context) => TodoListAddPage());
            await Navigator.push(context, route);
            setState(() {});
          },
          child: Icon(Icons.add_box),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: FutureBuilder(
            future: getTodoList(),
            builder: (ctx, dynamic snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<dynamic> data = snapshot.data;
                  return todolistCreate(data);
                } else {
                  return Text('Not data');
                }
              } else {
                return CircularProgressIndicator();
              }
            }));
  }

  Padding todolistCreate(List<dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (ctx, index) {
            var _data = data[index];
            return Card(
              child: ListTile(
                leading: Text(_data['id'].toString()),
                title: Text(_data['title'].toString()),
                subtitle: Text(_data['detail'].toString()),
                onTap: () async {
                  var route = MaterialPageRoute(
                      builder: (context) => TodoListEditPage(
                            data: data[index],
                          ));
                  Navigator.push(context, route).then((value) {
                    setState(() {});
                  });
                },
              ),
            );
          }),
    );
  }
}
