import 'package:flutter/material.dart';

class NeuromorphicContainer extends StatefulWidget {
  final Widget child;
  final double padding;
  final Color color;
  NeuromorphicContainer(
      {@required this.child, this.padding = 0, this.color = Colors.white});
  @override
  _NeuromorphicContainerState createState() => _NeuromorphicContainerState();
}

class _NeuromorphicContainerState extends State<NeuromorphicContainer> {
  // if(widget.color == Colors.blue){}
  var basicDec = BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment(-1.0, -4.0),
          end: Alignment(1.0, 4.0),
          colors: [
            Color(0xFF5bc6ff),
            Color(0xFF4da7db),
          ]),
      borderRadius: BorderRadius.all(Radius.circular(35)),
      boxShadow: [
        BoxShadow(
            color: Color(0xFF4ca5d8),
            offset: Offset(5.0, 5.0),
            blurRadius: 15.0,
            spreadRadius: 1.0),
        BoxShadow(
            color: Color(0xFF5ecdff),
            offset: Offset(-5.0, -5.0),
            blurRadius: 15.0,
            spreadRadius: 1.0),
      ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
      padding: EdgeInsets.all(widget.padding),
      decoration: basicDec,
    );
  }
}
