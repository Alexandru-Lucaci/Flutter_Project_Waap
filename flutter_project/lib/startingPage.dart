import 'package:flutter/material.dart';

class StartingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Go to Second Screen'),
          onPressed: () {
             /* 
            // Navigate to the second screen when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => (SecondScreen())),

            
            );
            */
          },
        ),
      ),
    );
  }
}