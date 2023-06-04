import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyStateApp();
  }
}

class MyStateApp extends State<LoginPage> {
// data members
  int? data = 0;
  var numbers = ['+40', '+44'];
  var selectedNumber = '+40';

  Widget GetBody() =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: 20.0),
        const Text("WhatsApp trebuie să vă verifice numărul de telefon",
            style: TextStyle(fontSize: 25.0)),
        const SizedBox(height: 15.0),
        DropdownButton<int>(
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
        const SizedBox(height: 15.0),
        Center(
            child: Row(
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
            SizedBox(
              width: 200.0,
              height: 30.0,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Numar de telefon',
                ),
              ),
            ),
          ],
        )),
        const Text(
          "Citiți Politica de confidențialitate. Atingeți „Acceptați și continuați” pentru a accepta Condițiile de utilizare",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0),
        ),
        const SizedBox(height: 50.0),
        Container(
          width: 300.0,
          height: 30.0,
          child: ElevatedButton(
              child: Text("Accepta si continua"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => (LoginPage())));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              )),
        ),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DropdownButton<int>(
                    value: 1,
                    items: [
                      DropdownMenuItem(
                        child: Text("Romana"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("Engleza"),
                        value: 2,
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        value = 1;
                      });
                    },
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
                    value = 1;
                  });
                },
              )
            ]),
        body: GetBody(),
      ));
}
