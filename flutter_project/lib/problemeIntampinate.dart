import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';

class ProblemeIntampinate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyStateApp();
  }
}

class MyStateApp extends State<ProblemeIntampinate> {
// data members

  Widget GetBody() => Center(
          child: Column(children: const [
        Text(
            'Nu s-a detectat un număr de telefon valid\nVă rugăm să mergeți la ecranul anterior și să introduceți un număr de telefon valid în formatul internațional\n\t1. Selectează țara din lista de țări. Acest lucra va importa automat țara în căsuța respectivă\n\t2. Introduceți numărul de telefon. Evitați orice cifră de 0 de la începutul numărului\nCa și exemplu, formatul corect pentru Statele Unite este +1 (408) 555-1234'),
      ]));
  @override
  Widget build(BuildContext context) => MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
            title: Text("Problemă întâmpinată"),
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
