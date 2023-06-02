import 'package:flutter/material.dart';

class StartingPage extends StatelessWidget {
  int LanguageSelected = 1; // 1 - romana, 2 - engleza
  String welcomeText = "";
  String welcomeText2 =
      "Citiți Politica de confidențialitate. Atingeți „Acceptați și continuați” pentru a accepta Condițiile de utilizare";
  String btnText = "Accepta si continua";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/whatsappFirstImage.png',
                width: 400.0, height: 400.0),
            SizedBox(height: 20.0),
            Text(welcomeText,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 15.0),
            Text(
              welcomeText2,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0),
            ),
            ElevatedButton(
              child: Text(btnText),
              onPressed: () {

              },
            ),
            SizedBox(height: 15.0),
            DropdownButton(
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
                  if (value == 1) {
                    welcomeText = "Bine ai venit la WhatsApp";
                    btnText = "Accepta si continua";
                  } else {
                    welcomeText = "Welcome to WhatsApp";
                    btnText = "Accept and continue";
                  }
                })
          ],
        ),

        // child: ElevatedButton(
        //   child: Text('Go to Second Screen'),
        //   onPressed: () {
        //      /*
        //     // Navigate to the second screen when the button is pressed
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => (SecondScreen())),

        //     );
        //     */
        //   },
        // ),
      ),
    );
  }
}
