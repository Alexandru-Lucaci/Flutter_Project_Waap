import 'package:flutter/material.dart';
import 'loginPage.dart';

class StartingPage extends StatelessWidget {
  int LanguageSelected = 1; // 1 - romana, 2 - engleza
  String welcomeText = "Bun venit pe WhatsApp";
  String welcomeText2 =
      "Citiți Politica de confidențialitate. Atingeți „Acceptați și continuați” pentru a accepta Condițiile de utilizare";
  String btnText = "Accepta si continua";
  String selectLangBtn = "Selecteaza limba";
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
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 50.0),
            Container(
              width: 300.0,
              height: 30.0,
              child: ElevatedButton(
                  child: Text(btnText),
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
                        value: LanguageSelected,
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
                            LanguageSelected = 1;
                            welcomeText = "Bine ai venit la WhatsApp";
                            welcomeText2 =
                                "Citiți Politica de confidențialitate. Atingeți „Acceptați și continuați” pentru a accepta Condițiile de utilizare";
                            btnText = "Accepta si continua";
                          } else {
                            LanguageSelected = 2;
                            welcomeText = "Welcome to WhatsApp";
                            btnText = "Accept and continue";
                            welcomeText2 =
                                "Read our Privacy Policy. Tap 'Agree and continue' to accept the Terms of Service";
                          }
                        },
                        icon: Icon(Icons.language),
                        hint: Text(selectLangBtn),
                      ),
                    )))
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
