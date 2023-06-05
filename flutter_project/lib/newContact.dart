import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'problemeIntampinate.dart';
import 'mainMessagePage.dart';

class NewContact extends StatefulWidget {
  // NewContact(Results? results);

  Results? results;
  NewContact(this.results);

  @override
  State<StatefulWidget> createState() {
    return MyStateApp(results);
  }
}

class MyStateApp extends State<NewContact> {
// data members
  int? data = 0;
  var accounts = 'accounts';
  var numbers = ['+40', '+44'];
  var selectedNumber = '+40';
  var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: 'alex852654',
      db: 'flutter_proj');
  bool firstInput = false;
  bool secondInput = true;
  TextEditingController numberController = TextEditingController();
  TextEditingController suggestedName = TextEditingController();
  Results? results;
  MyStateApp(this.results);
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

  Widget GetBody() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 20.0),
        const SizedBox(height: 15.0),
        Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.green, width: 2))),
              child: SizedBox(
                width: 250.0,
                height: 30.0,
                child: TextField(
                  controller: numberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Număr de telefon',
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.length > 0) {
                        firstInput = true;
                        print(value);
                      } else {
                        firstInput = false;
                      }
                    });
                  },
                  enabled: secondInput,
                ),
              ),
            ),
          ],
        )),
        const SizedBox(height: 15.0),
        Center(
          child: Container(
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.green, width: 2))),
            child: SizedBox(
              width: 250.0,
              height: 30.0,
              child: TextField(
                controller: suggestedName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nume de utilizator sugerat',
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.length > 0) {
                      secondInput = false;
                      print(value);
                    } else {
                      secondInput = true;
                    }
                  });
                },
                enabled: !firstInput,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15.0),
        const SizedBox(height: 50.0),
      ]);
  @override
  Widget build(BuildContext context) => MaterialApp(
          home: Scaffold(
        appBar: AppBar(
            title: Text("Contact nou"),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            leading: CloseButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () async {
                  if (suggestedName.text.length > 0) {
                    final conn = await MySqlConnection.connect(settings);
                    var result = await conn.query(
                        'SELECT * FROM accounts WHERE name = ?',
                        [suggestedName.text]);
                    if (result.isEmpty) {
                      responsePopUp('Nu am gasit numele',
                          'Nu am gasit numele de utilizator in baza de date');
                    } else {
                      print('Results id is ${results!.first[0]}');
                      var myId = results!.first[0];
                      var id = result.first[0];
                      print('the id is $id');
                      //  check if the are already friends
                      var result2 = await conn.query(
                          'SELECT * FROM friends WHERE idFriend1 = ? AND idFriend2 = ? or idFriend1 = ? AND idFriend2 = ?',
                          [myId, id, id, myId]);

                      if (result2.isEmpty) {
                        // get the max id
                        var q = await conn.query('SELECT MAX(id) FROM friends');
                        var maxId = q.first[0];
                        // i can add the friend

                        var result3 = await conn.query(
                            'INSERT INTO friends (id,idFriend1, idFriend2) VALUES (?, ?, ?)',
                            [maxId + 1, myId, id]);
                        responsePopUp('Adding friend', 'You are now friends');
                      } else {
                        responsePopUp(
                            "Adding friend", "You are already friends");
                      }
                    }
                  } else {
                    if (numberController.text.length > 0) {
                      final conn = await MySqlConnection.connect(settings);
                      var result = await conn.query(
                          'SELECT * FROM accounts WHERE number = ?',
                          [numberController.text]);
                      if (result.isEmpty) {
                        responsePopUp('Error',
                            'Nu am gasit numarul de telefon in baza de date');
                      } else {
                        print('Results id is ${results!.first[0]}');
                        var myId = results!.first[0];
                        var id = result.first[0];
                        print('the id is $id');
                        //  check if the are already friends
                        var result2 = await conn.query(
                            'SELECT * FROM friends WHERE idFriend1 = ? AND idFriend2 = ? or idFriend1 = ? AND idFriend2 = ?',
                            [myId, id, id, myId]);

                        if (result2.isEmpty) {
                          // get the max id
                          var q =
                              await conn.query('SELECT MAX(id) FROM friends');
                          var maxId = q.first[0];
                          // i can add the friend

                          var result3 = await conn.query(
                              'INSERT INTO friends (id,idFriend1, idFriend2) VALUES (?, ?, ?)',
                              [maxId + 1, myId, id]);
                          responsePopUp('Adding friend', 'You are now friends');
                        } else {
                          responsePopUp(
                              "Adding friend", "You are already friends");
                        }
                      }
                    } else {
                      responsePopUp('Error',
                          'Nu am gasit numarul de telefon in baza de date');
                    }
                  }
                },
              )
            ]),
        body: GetBody(),
      ));
}
