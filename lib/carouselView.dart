import 'package:flutter/material.dart';
class Show extends StatefulWidget
{
  String url;
  Show({Key key, @required this.url }) : super (key: key);

  @override 
  _ShowState createState() => new _ShowState();

}

class _ShowState extends State<Show>{
  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      backgroundColor: Colors.lightBlue,

      appBar: AppBar(
        title: Text("Image"),
      ),
        
      body: Image.network(widget.url, width: double.infinity,)
    );
  }
}