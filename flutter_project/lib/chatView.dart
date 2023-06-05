import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'problemeIntampinate.dart';
import 'registerPage.dart';
import 'NewContact.dart';

class ChatView extends StatefulWidget {
  Results? results;
  int idSender, idReciever;
  ChatView(this.results, this.idSender, this.idReciever);

  @override
  State<StatefulWidget> createState() {
    return MyStateApp(results, idSender, idReciever);
  }
}

class MyStateApp extends State<ChatView> {
// data members
  int? data = 0;
  var menuId = 1; // 1- chats / 2 -groups
  var accounts = 'accounts';
  var numbers = ['+40', '+44'];
  var selectedNumber = '+40';
  var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: 'alex852654',
      db: 'flutter_proj');
  int idSender, idReciever;
  Results? results;
  TextEditingController nameController = TextEditingController();
  var inputNumber = '';
  MyStateApp(this.results, this.idSender, this.idReciever);

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  getlenghtOfList(var list) {
    print(list.toString());
    return list;
  }

  responsePopUp(String text1, String text2) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(text1),
            content: Text(text2),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  getNameFromId(id) async {
    var conn = await MySqlConnection.connect(settings);
    var name = await conn.query('select * from accounts where id = ?', [id]);
    return name.elementAt(0)[1];
  }

  getIdFromName(name) async {
    var conn = await MySqlConnection.connect(settings);
    var id = await conn.query('select * from accounts where name = ?', [name]);
    return id.elementAt(0)[0];
  }

  Future<List<String>>? getAllData(var data) async {
    print('here0');
    var myData = data?.elementAt(0);
    print(myData);
    final conn = await MySqlConnection.connect(settings);
    print('here1');

    print('data is $myData');
    var friend = await conn.query(
        'select * from friends where idFriend1 = ? or idFriend2 = ?',
        [myData[0], myData[0]]);
    print('here2');
    // print(friend.toString());
    var listWithFriends = [];
    print('here4 ${friend.length}');
    for (int i = 0; i < friend.length; i++) {
      var row = friend.elementAt(i);

      if (row[1] == myData[0]) {
        listWithFriends.add(row[2]);
      } else {
        listWithFriends.add(row[1]);
      }
    }
    print(listWithFriends.toString());
    print('here');
    // make unique list
    listWithFriends = listWithFriends.toSet().toList();
    // get all the names of the friends
    List<String> listWithFriendsNames = [];
    var friendName;
    for (var i = 0; i < listWithFriends.length; i++) {
      friendName = await conn
          .query('select * from accounts where id = ?', [listWithFriends[i]]);
      for (var row in friendName) {
        listWithFriendsNames.add(row[1]);
      }
    }
    return listWithFriendsNames;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
          home: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewContact(results)),
                );
              },
            )
          ],
        ),
        body: Row(),
      ));
}
