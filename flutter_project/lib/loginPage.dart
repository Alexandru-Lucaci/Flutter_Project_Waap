import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'problemeIntampinate.dart';
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyStateApp();
  }
}

class MyStateApp extends State<LoginPage> {
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

  TextEditingController nameController = TextEditingController();
  var inputNumber = '';
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  bool checkConnection(bool workingDB, String number, String region,
      [String? inputNumber, String? inputRegion]) {
    if (workingDB == true) {
      if (inputNumber == number && inputRegion == region) {
        return true;
      } else {
        return false;
      }
    } else {
      if (inputNumber == '0745881174' && inputRegion == 'RO') {
        return true;
      } else {
        return false;
      }
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
  Widget GetBody() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 20.0),
        const Text("WhatsApp trebuie să vă verifice numărul de telefon",
            style: TextStyle(fontSize: 25.0)),
        const SizedBox(height: 15.0),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.green, width: 2),
            ),
          ),
          child: DropdownButton<int>(
          value: data,
          items: const [
            DropdownMenuItem(
              child:  Text("România"),
              
              value: 0,
            ),
            DropdownMenuItem(
              child:  Text("United Kindom"),
              value: 1,
            ),
          ],
          onChanged: (value) {
            setState(() {
              data = value;
              selectedNumber = numbers[value!];
            });
          },
        ),
        ),
        
        const SizedBox(height: 15.0),
        Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.green, width: 2),
                      )),
              child: SizedBox(
                width: 100.0,
                height: 30.0,
                child: Text(
                  selectedNumber,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.green, width: 2))),
              child: SizedBox(
                width: 200.0,
                height: 30.0,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Număr de telefon',
                  ),
                  
                ),
              ),
            ),
            
          ],
        )),
        const SizedBox(height: 15.0),
        const Text(
          "Este posibil ca operatorul să perceapă taxe",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0),
        ),
        const SizedBox(height: 50.0),
    
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: 
                  Container(
                    width: 100.0,
                    height: 30.0,
                    child: ElevatedButton(
                        child: Text("Înainte"),
                        onPressed: () async {
                          try {
                            final conn =
                                await MySqlConnection.connect(settings);

                            // get the data from the input field
                            // var name = nameController.text;
                            inputNumber = nameController.text;
                            var results = await conn.query(
                                'select * from accounts where number = ?',
                                [inputNumber]);
                            for (var row in results) {
                              print(
                                  'Name: ${row[0]}, name: ${row[1]}, number: ${row[2]}, region: ${row[3]}');
                            }
                            if (results.isEmpty) {
                              responsePopUp('Numarul de telefon nu exista',
                                  'Numarul de telefon nu exista in baza de date. Va rugam sa va creati un cont.');
                            } else {
                              if (checkConnection(
                                  true,
                                  results.elementAt(0)[2],
                                  results.elementAt(0)[3],
                                  inputNumber,
                                  selectedNumber)) {
                                responsePopUp('Numarul de telefon exista',
                                    'Va vom conecta imediat  la contul dvs.');
                              } else {
                                responsePopUp('Numarul de telefon nu exista',
                                    'Numarul de telefon nu exista in baza de date. Va rugam sa va creati un cont.');
                              }
                            }
                          } catch (e) {
                            print(e);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Fail $e'),
                                    content: const Text(
                                        'Trying to connect to the default account.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          if (inputNumber == '0745881174') {
                                            if (selectedNumber == '+40') {
                                              responsePopUp(
                                                  'Numarul de telefon exista',
                                                  'Va vom conecta imediat  la contul dvs.');
                                            } else {
                                              responsePopUp(
                                                  'Numarul de telefon nu exista',
                                                  'Numarul de telefon nu exista in baza de date. Va rugam sa va creati un cont.');
                                            }
                                          }
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          backgroundColor: Colors.green.shade700,
                        )),
                  ),
                ))),
      ]);
  @override
  Widget build(BuildContext context) => MaterialApp(
          home: Scaffold(
        appBar: AppBar(
            title: Text("Introduceți numărul de telefon"),
            foregroundColor: Colors.green,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Creaza un cont"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Ajutor"),
                  ),
                ],
                onSelected: (value) {
                  setState(() {
                    if (value == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => (ProblemeIntampinate())));
                    } else {}
                  });
                },
              )
            ]),
        body: GetBody(),
      ));
}
