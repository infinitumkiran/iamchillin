import 'package:flutter/material.dart';
import 'package:iamcool/util/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class climate extends StatefulWidget {
  @override
  _climateState createState() => _climateState();
}

class _climateState extends State<climate> {
  void showstuff() async {
    Map data = await getWeather(appId, defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('CLIMATE'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                  const IconData(58834, fontFamily: 'MaterialIcons')),
              onPressed: showstuff),
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/snow.jpg',
              width: 400.0,
              height: 1000.0,

              fit: BoxFit.fill,
            ),
          ),

          new Container(
            child: new Image.asset('images/rainy.jpg',
              width: 400.0,
              height: 710.0,
              fit: BoxFit.fill,
            ),
          ),


          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 70.0, 0.0, 0.0),
            alignment: Alignment.topLeft,
            child: new Image.asset('images/rainy.png',
              width: 150.0,
              height: 150.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(90.0, 90.0, 0.0, 0.0),
            alignment: Alignment.topCenter,
            child: new Text('67.8F',
                style: tempstyle()
            ),
          ),
          new Container(


            margin: const EdgeInsets.fromLTRB(135.0, 50.0, 0.0, 430.0),
            alignment: Alignment.center,
            child: updateTempWidget(String city),


          ),

        ],

      ),
    );
  }
}

Widget updateTempWidget(String city) {
  return new FutureBuilder
  (
      future: getWeather(appId, city),
  builder:(BuildContext context, AsyncSnapshot<Map> snapshot){
  if (snapshot.hasData) {
  Map content = snapshot.data,
  // ignore: missing_return, missing_return
  return new Container(
  child: new Column(
  children: <Widget>[
  new ListTile(
  title: new Text(content['main']['temp'.toString()]),
  )
  ]


  )
  );
  }
  },
},);
}

Future<Map> getWeather(String appId, String city) async {
  String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city ,india&appid=$appId';
  http.Response response = await http.get(apiUrl);
  return jsonDecode(response.body);
}


TextStyle citystyle() {
  return new TextStyle(
    color: Colors.green,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w900,
    fontSize: 25.0,
  );
}

TextStyle tempstyle() {
  return new TextStyle(
    color: Colors.amber,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
    fontSize: 49.9,
  );
}}