import 'package:bullseye/hit_me_button.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Bullseye'),
        backgroundColor: Colors.red,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Bullseye',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HitMeButton(
              text: 'Go Back!',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      )),
    );
  }
}
