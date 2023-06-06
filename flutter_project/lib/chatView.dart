import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'NewContact.dart';

class ChatView extends StatefulWidget {
  Results? results;
  int idSender;
  String idReciever;
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
//   CREATE USER 'root'@'ip_address' IDENTIFIED BY 'some_pass';
// GRANT ALL PRIVILEGES ON *.* TO 'root'@'ip_address';
  var settings = ConnectionSettings(
      host: '192.168.43.142',
      port: 3306,
      user: 'root',
      password: 'alex852654',
      db: 'flutter_proj');
  int idSender;
  String idReciever;
  Results? results;
  TextEditingController nameController = TextEditingController();
  var inputNumber = '';

  var controller;

  var textController;
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

  Future<String>? getNameFromId(id) async {
    var conn = await MySqlConnection.connect(settings);
    var name = await conn.query('select * from accounts where id = ?', [id]);
    print(name.elementAt(0)[1]);
    return name.elementAt(0)[1];
  }

  getIdFromName(name) async {
    var conn = await MySqlConnection.connect(settings);
    var id = await conn.query('select * from accounts where name = ?', [name]);
    return id.elementAt(0)[0];
  }

  Future<Map<String, String>> getAllMessages() async {
    var conn = await MySqlConnection.connect(settings);
    var realId = await getIdFromName(idReciever);
    var messages = await conn.query(
        'select sender,message from messages where sender = ? and reciever = ? or sender = ? and reciever = ?',
        [idSender, realId, realId, idSender]);
    Map<String, String> listWithMessages = {};
    for (var row in messages) {
      listWithMessages[row[1]] = row[0].toString();
    }
    if (messages.length == 0) {
      return {'no messages': '-1'};
    } else {
      return listWithMessages;
    }
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
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: ListTile(
            title: Text(idReciever),
            leading: CircleAvatar(
              child: Text(idReciever[0]),
            ),
          ),
          // add back button
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          //Text(idReciever),
          backgroundColor: Colors.green.shade700,
          actions: <Widget>[
            IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: Icon(Icons.call)),
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
        body: Column(
          children: [
            FutureBuilder(
              future: getAllMessages(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data.toString());
                  if (snapshot.data.toString() == '{no messages: -1}') {
                    return Text('No messages');
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  // borderRadius: BorderRadius.circular(10),
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade800))),
                              child: ListTile(
                                title:
                                    Text(snapshot.data!.keys.elementAt(index)),
                                subtitle: Text(
                                    snapshot.data?.values.elementAt(index) ==
                                            idSender.toString()
                                        ? 'You'
                                        : idReciever),
                              ));
                        },
                      ),
                    );
                  }
                } else {
                  return Center(child: Text('No messages'));
                }
              },
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Introdu Mesajul',
                ),
                onSubmitted: (value) async {
                  addMessage(value);
                  setState(() {
                    // reopen the page
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatView(results, idSender, idReciever)),
                    );
                  });
                },
              ),
              // IconButton(
              //     onPressed: () {
              //       setState(() async {
              //         // items.add(text);
              //         addMessage(textController.text);
              //         textController.clear();
              //       });
              //     },
              //     icon: Icon(Icons.send))
            )
            // Row(
            //   children: [
            //     TextField(
            //       controller: controller,
            //       decoration: InputDecoration(
            //         labelText: 'Adăugați un element',
            //         labelStyle: TextStyle(color: Colors.blue.shade700),
            //       ),
            //       onSubmitted: (text) {
            //         setState(() async {
            //           // items.add(text);
            //           addMessage(controller.text);
            //           controller.clear();
            //         });
            //       },
            //     ),
            //   ],
            // )
          ],
        ),
      ));

  void addMessage(text) async {
    var conn = await MySqlConnection.connect(settings);
    var realId = await getIdFromName(idReciever);
    // get the max id
    dynamic maxId = await conn.query('select max(id) from messages');
    if (maxId.elementAt(0)[0] == null) {
      maxId = 0;
    } else {
      maxId = (maxId.elementAt(0)[0] as int) + 1;
    }
    var results = await conn.query(
        'insert into messages(id, sender,reciever,message) values(?,?,?,?)',
        [maxId, idSender, realId, text]);
  }
}
