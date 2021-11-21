import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '/conf/config.dart';

class TodoListAddPage extends StatefulWidget {
  TodoListAddPage({Key? key}) : super(key: key);

  @override
  _TodoListAddPageState createState() => _TodoListAddPageState();
}

class _TodoListAddPageState extends State<TodoListAddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  void onPressed() {
    print('title : ${titleController.text}');
    print('body : ${bodyController.text}');
  }

  Future postTodo() async {
    //var url = Uri.parse('https://0349-2403-6200-8817-f195-6914-383b-e25-266b.ngrok.io/api/create-todolist');
    var url = Uri.parse(APIRoutes['todo-create']!);
    //print(url);
    var headers = {'Content-Type': 'application/json; charset=utf-8'};
    Map<String, String> data = {'title': titleController.text.toString(), 'detail': bodyController.text.toString()};

    final response = await http.post(url, headers: headers, body: jsonEncode(data));
    print(response.body);
    if (response.statusCode == 201) {
      return [json.decode(response.body.toString())];
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todolist : เพิ่มรายการ"),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [inputTitle(), spaceNewLine(), inputBody(), spaceNewLine(), submitSave()],
        ),
      ),
    );
  }

  SizedBox spaceNewLine() {
    return SizedBox(
      height: 20,
    );
  }

  TextButton submitSave() {
    return TextButton(
        onPressed: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          await postTodo().then((value) {
            titleController.clear();
            bodyController.clear();
            String msg = "บันทึกข้อมูลเรียบร้อย";
            Color c = Colors.blue;
            if (value.length == 0) {
              msg = "ไม่สามารถบันทึกได้";
              c = Colors.red;
            }

            final snackBar = SnackBar(
                backgroundColor: Colors.white,
                duration: Duration(seconds: 1),
                content: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Text(
                    '$msg',
                    style: TextStyle(color: c, fontSize: 18),
                  ),
                )));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
          setState(() {});
        },
        child: Text('เพิ่มรายการ'),
        style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            textStyle: TextStyle(fontSize: 18),
            side: BorderSide(color: Colors.blueAccent, width: 1)));
  }

  TextField inputTitle() {
    return TextField(
      controller: titleController,
      decoration: InputDecoration(
        labelText: 'รายการที่ต้องทำ',
        border: OutlineInputBorder(),
      ),
    );
  }

  TextField inputBody() {
    return TextField(
      controller: bodyController,
      minLines: 3,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'รายละเอียด',
        border: OutlineInputBorder(),
      ),
    );
  }
}
