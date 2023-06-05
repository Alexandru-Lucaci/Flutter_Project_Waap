import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'problemeIntampinate.dart';
import 'registerPage.dart';
import 'NewContact.dart';
class MainMessagePage extends StatefulWidget {
  Results? results;
  MainMessagePage(this.results);

  @override
  State<StatefulWidget> createState() {
    return MyStateApp(results);
  }
}

class MyStateApp extends State<MainMessagePage> {
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
  Results? results;

  TextEditingController nameController = TextEditingController();
  var inputNumber = '';
  MyStateApp(this.results);

  
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  getlenghtOfList(var list) {
    print(list.toString());
    return list;
  }

  Future<List<String>>? getLastMessage([var id1, var id2]) async {
    final conn = await MySqlConnection.connect(settings);
    print('here i am i gues');
    print(id1);
    print(id2.toString());
    var myData = results?.elementAt(0);

    var lastMessage = await conn.query(
        'select  message from messages where sender = ? and reciever = ? or sender = ? and reciever = ? ',
        [id1, id2, id2, id1]);
    print('here i am i gues2');
    for (var row in lastMessage) {
      print(row);
    }
   
   
    conn.close();
    try {
      return [lastMessage.elementAt(lastMessage.length - 1)[0]];
    } catch (e) {
      return ['Last message'];
    }
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
  
  getLastDate([var id2]) async {
    final conn = await MySqlConnection.connect(settings);
    print('here i am i gues');
    print(id2);
    var id1 = results?.elementAt(0)[0];

    var lastMessage = await conn.query(
        'select created_at from messages where sender = ? and reciever = ? or sender = ? and reciever = ? ',
        [id1, id2, id2, id1]);
    print('here i am i gues2');
    for (var row in lastMessage) {
      print(row);
    }
    conn.close();
    try {
      return [lastMessage.elementAt(lastMessage.length - 1)[0]];
    } catch (e) {
      return ['Last message'];
    }
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

        body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 768) {
            // mobile
            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Scaffold(
                        appBar: AppBar(
                          title: Text("WhatsApp"),
                          backgroundColor: Colors.green.shade700,
                          actions: [
                            IconButton(
                                onPressed: () => {},
                                icon: Icon(Icons.camera_alt)),
                            IconButton(
                                onPressed: () => {}, icon: Icon(Icons.search)),
                            PopupMenuButton<int>(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 1,
                                  child: Text("Adauga prieten"),
                                ),
                                const PopupMenuItem(
                                  value: 2,
                                  child: Text("new group"),
                                ),
                              ],
                              onSelected: (value) {
                                setState(() {
                                  if (value == 2) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                (ProblemeIntampinate())));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                (NewContact(results))));
                                  }
                                });
                              },
                            )
                          ],
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(50.0),
                            child: Row(
                              children: [
                                Container(
                                  width: constraints.maxWidth / 2,
                                  child: IconButton(
                                    onPressed: () => {
                                      setState(() {
                                        menuId = 0;
                                      })
                                    },
                                    icon: Icon(Icons.group),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                      width: constraints.maxWidth / 2,
                                      child: TextButton(
                                          onPressed: () => {
                                                setState(() {
                                                  menuId = 1;
                                                })
                                              },
                                          style: TextButton.styleFrom(
                                            primary: Colors.white,
                                          ),
                                          child: SafeArea(
                                            child: LayoutBuilder(
                                                builder: (context, constr) {
                                              return Row(children: [
                                                Container(
                                                  width: constr.maxWidth / 2,
                                                  child: const Text(
                                                    'chats',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ]);
                                            }),
                                          ))),
                                )
                              ],
                            ),
                          ),
                        ),
                        body: FutureBuilder(
                          future: getAllData(results),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data
                                      .toString()
                                      .split(',')
                                      .length,
                                  itemBuilder: (BuildContext context, index) {
                                    try {
                                      return ListTile(
                                        title: Text(snapshot.data![index]),
                                      subtitle: FutureBuilder(
                                          future: getLastMessage(
                                              results
                                                  ?.elementAt(0)[0]
                                                  .toString(),
                                              index),
                                          builder: (BuildContext context2,
                                              AsyncSnapshot<List<String>>
                                                  snapshot2) {
                                            if (snapshot2.hasData) {
                                              return Text(snapshot2.data![0]);
                                            } else {
                                              return Text('Last message');
                                            }
                                          }),
                                      leading: CircleAvatar(
                                        child: Text(snapshot.data![index][0]),
                                      ),

                                      onTap: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProblemeIntampinate()))
                                      },
                                      // date in the right
                                        trailing: Text('date'),
                                      );
                                    } catch (e) {
                                      return ListTile(
                                        title: Text('No friends'),
                                      );
                                    }
                                    
                                  });
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        )),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            );
          } else {
            if (constraints.maxWidth < 1200) {
              // web
              return Row(
                children: [
                  Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text("AppBar"),
                      ),
                      body: Text("Body"),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ))
                ],
              );
            } else {
              return Row(
                children: [
                  Container(
                    width: 450,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  )
                ],
              );
            }
          }
        })),
      ));
}
