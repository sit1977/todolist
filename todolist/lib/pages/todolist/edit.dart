import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '/conf/config.dart';

class TodoListEditPage extends StatefulWidget {
  final data;
  TodoListEditPage({Key? key, this.data}) : super(key: key);

  @override
  _TodoListEditPageState createState() => _TodoListEditPageState();
}

class _TodoListEditPageState extends State<TodoListEditPage> {
  String id = '0';
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  void onPressed() {
    //print('title : ${titleController.text}');
    //print('body : ${bodyController.text}');
  }

  Future updateTodo() async {
    //var url = Uri.parse('https://0349-2403-6200-8817-f195-6914-383b-e25-266b.ngrok.io/api/create-todolist');
    var url = Uri.parse(APIRoutes['todo-update']! + id.toString());
    //print(url);
    var headers = {'Content-Type': 'application/json; charset=utf-8'};
    Map<String, String> data = {'title': titleController.text.toString(), 'detail': bodyController.text.toString()};

    final response = await http.put(url, headers: headers, body: jsonEncode(data));
    //print(response.body);
    if (response.statusCode == 200) {
      return [json.decode(response.body.toString())];
    } else {
      return [];
    }
  }

  Future deleteTodo() async {
    var url = Uri.parse(APIRoutes['todo-delete']! + id.toString());
    final response = await http.delete(url);
    //print(response.statusCode);
    if (response.statusCode == 200) {
      //print(response.body.toString());
      //return [json.decode(response.body.toString())];
      Navigator.pop(context);
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    id = widget.data['id'].toString();
    titleController.text = widget.data['title'].toString();
    bodyController.text = widget.data['detail'].toString();
    // print(widget.data['title']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todolist : ปรับปรุ่งรายการ"),
        actions: [
          IconButton(
              onPressed: () async {
                showAlertDialog(context);
                // print('Delete ID $id');
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            inputTitle(),
            spaceNewLine(),
            inputBody(),
            spaceNewLine(),
            submitSave(),
            // spaceNewLine(),
            // submitDelete()
          ],
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
          await updateTodo().then((value) {
            print(value);
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
          //setState(() {});
          Navigator.pop(context);
        },
        child: Text('ปรับปรุ่ง'),
        style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.blueAccent,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            textStyle: TextStyle(fontSize: 18),
            side: BorderSide(color: Colors.blueAccent, width: 1)));
  }

  TextButton submitDelete() {
    return TextButton(
        onPressed: () async {
          await deleteTodo().then((value) {
            Navigator.pop(context);
          });
        },
        child: Text('ลบข้อมูล'),
        style: TextButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.redAccent,
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

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("ยกเลิก"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("ลบข้อมูล"),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ยืนยัน"),
      content: Text("คุณต้องการลบข้อมูลของ '" + widget.data['title'].toString() + "'"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) {
      print(value);
      if (value == true) {
        deleteTodo();
      }
    });
  }
}
