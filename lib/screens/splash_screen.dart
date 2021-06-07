import 'package:blogger_flutter/mywidgets/neu.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color(0xFF55b9f3),
        body: Column(
      children: [
        NeuromorphicContainer(
            padding: 80.5,
            child: Container(
              child: Text("Welcome"),
            )),
      ],
    ));
  }
}
