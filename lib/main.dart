import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'carouselView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beasts App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'DOTA Beasts'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //prep carousel
  
  List ImageData;
  String urlpath = "https://api.opendota.com/api/heroStats";
  // Function to get the JSON ImageData
  Future<String> getJSONData() async {
    var response = await http.get(
        // Encode the url
        Uri.encodeFull(urlpath),
        // Only accept JSON response
        headers: {"Accept": "application/json"});

    setState(() {
      // Get the JSON ImageData
      ImageData = json.decode(response.body);
      print(ImageData);
   });

    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: buildListView(),
    );
  }

  Widget buildListView() {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: ImageData == null ? 0 : ImageData.length,
        itemBuilder: (context, index) {
          return buildImageColumn(ImageData[index]);
          // return _buildRow(ImageData[index]);
        });
  }

  Widget buildImageColumn(dynamic item) => Container(
        decoration: BoxDecoration(color: Colors.purple),
        margin: const EdgeInsets.fromLTRB(0, 3, 0, 6),
        child: Column(
          children: [
            new CachedNetworkImage(
              //imageUrl: item['img']+ "/"+urlpath ,
              imageUrl: "https://api.opendota.com" + item['img'],
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
              fadeOutDuration: new Duration(seconds: 2),
              fadeInDuration: new Duration(seconds: 4),
            ),
            buildRow(item)
          ],
        ),
      );

  Widget buildRow(dynamic item) {
    return ListTile(
        title: Align(
          child: new Text(
              item['localized_name'] == null ? '' : item['localized_name']),
          alignment: Alignment(0, 0),
        ),
        onTap: () {
          showDialog(
              context: context,
              child: new AlertDialog(
                titlePadding: new EdgeInsets.symmetric(vertical: 2.0, horizontal: 2),
                // contentPadding: EdgeInsets.fromLTRB(12,0,32,0),
                elevation: 50.0,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18)
                ),
                backgroundColor: Colors.lightGreen,
                title: new Column(
                  children: <Widget>[
                    new Text("You clicked:", ),
                  ],
                ),
                content: new Text(item['localized_name']),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                              name: item['name'],
                              attackType: item['attack_type']),
                        ),
                      );
                    },
                    child: new Text('OK'),
                  ),
                ],
              ));
        });
  }

  @override
  void initState() {
    super.initState();
    // Call the getJSONData() method when the app initializes
    this.getJSONData();
  }
}

// App goes to this screen when a listview item was pressed

class DetailScreen extends StatefulWidget {

    DetailScreen({Key key, this.name, this.attackType}) : super(key: key);

    final String name;
    final String attackType;

  @override
  _DetailScreen createState() => _DetailScreen();
} 

class _DetailScreen extends State<DetailScreen> {
  
  int _current = 0;
    final List imgList = [
    // '../images/wolf_beast.jpg',
    // '../images/beast.jpg'

    'https://images.unsplash.com/photo-1502117859338-fd9daa518a9a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1554321586-92083ba0a115?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1536679545597-c2e5e1946495?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1543922596-b3bbaba80649?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
    'https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80'
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("More info"),
      ),
      body: 
      
        Padding(
          padding: EdgeInsets.all(16.0),
          // child: Text("Name: " + name + " "+ 'attackType'+ "= "+ attackType ) ,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Attack Type:" + widget.attackType),
              Text("Name:" +  widget.name),
              CarouselSlider(
                height: 400.00,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlay: true,
                // reverse: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                onPageChanged: (index) {
                  // setState(() {
                  //   _current = index;
                  // });
                },
                items: 
                imgList.map((a) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                        child:
                          GestureDetector(
                            child: Image.network(
                           a,
                          fit: BoxFit.fill,),
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Show(url:a)));
                          },   
                         )  
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          )),
    );
  }
}
