import 'package:flutter/material.dart';
import 'package:iamcool/util/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ClimateView extends StatefulWidget {
  @override
  _ClimateViewState createState() => _ClimateViewState();
}

class _ClimateViewState extends State<ClimateView> {
  String cityentered;


  Future _goToNextScreen(BuildContext context) async{
    Map results = await Navigator.of(context).push(
       MaterialPageRoute<Map>(builder: (BuildContext context){
        return ChangeCity();
      })

    );
    if(results!=null&&results.containsKey('enter')){
      cityentered=results['enter'];
    }
  }
  Util obj = new Util();
  void showStuff() async {
    Map data = await getWeather(obj.appId, obj.defaultCity);
    print(data.toString());
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city &appid=$appId';
    http.Response response = await http.get(apiUrl);
    return jsonDecode(response.body);
  }

  TextStyle cityStyle() {
    return TextStyle(
      color: Colors.green,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w900,
      fontSize: 30.0,
    );
  }

  TextStyle tempStyle() {
    return TextStyle(
      color: Colors.amber,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500,
      fontSize: 42.0,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward), onPressed: () {
            _goToNextScreen(context);}),
            IconButton(color:Colors.black,icon: Icon(Icons.more_vert), onPressed: null ),


        ],
        title: Text('CLiMATe'),
        centerTitle: true,

      ),
      body: Stack(

        children: <Widget>[
          Center(
            child: Image.asset(
              'images/snow.jpg',
              width: 400.0,
              height: 1000.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(

            child: Image.asset(
              'images/rainy.jpg',
              width: 400.0,
              height: 710.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(50.0, 90.0, 0.0, 0.0),
            alignment: Alignment.topLeft,
            child: Image.asset(
              'images/rainy.png',
              width: 150.0,
              height: 150.0,
              fit: BoxFit.fill,
            ),
          ),




          Container(
            margin: const EdgeInsets.fromLTRB(180.0, 250.0, 0.0, 0.0),
            alignment: Alignment.topCenter,
            child: Text(
                '${cityentered==null?obj.defaultCity:cityentered}',
              style:cityStyle(),
            ),

          ),
          Container(
              margin: const EdgeInsets.fromLTRB(225.0, 0.0, 0.0, 280.0),
              alignment: Alignment.center,
              child: updateTempWidget(cityentered),

            ),


        ],


      ),
    );
  }
  Widget updateTempWidget(String city){
    Util o=new Util();
    TextStyle windStyle() {
      return TextStyle(

        color: Colors.yellowAccent,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w500,
        fontSize: 20.0,
      );
    }
    return FutureBuilder(

      future: getWeather(obj.appId, city==null?o.defaultCity:city),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        return Container(

          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(0.0,80.0,0.0,0.0),
          child: Column(
              children: <Widget>[
                ListTile(
                  title: Text((snapshot.data['main']['temp'] - 273.15)
                      .toStringAsFixed(2) + '°C ',
                    style: tempStyle(),),
                  subtitle: ListTile(

                    title: Text(
                      "Wind Speed:${snapshot.data['wind']['speed'].toString()}km/h\n"
                          "Humidity:${snapshot.data['main']['humidity'].toString()}%\n"
                          "Pressure:${snapshot.data['main']['pressure'].toString()}m/b",
                      style: windStyle(),
                    ),
                  ),

                ),

              ]
          ),
        );
      },
    );


  }

}
class ChangeCity extends StatelessWidget {



  ClimateView o=new ClimateView();
  var _cityFieldController=new TextEditingController();
  TextStyle locstyle() {
    return TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500,
      fontSize: 22.9,
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title:Text('Location',
                style:locstyle() ,),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[

           ListView(

               shrinkWrap: true,
            children: <Widget>[
               Image.asset('images/location.jpg',
               width: 300.0,
               height:750.0,
                 fit: BoxFit.fill,
               ),
               ListView(

                 shrinkWrap: true,
                children: <Widget>[

                   ListTile(
                    title: TextField(
                      onChanged: (text){
                        print(text);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your city'
                      ),
                      controller:  _cityFieldController,
                      keyboardType:  TextInputType.text,
                    ),

                  ),
                  ListTile(

                    title:FlatButton(

                        onPressed: (){
                          Navigator.pop(context,{
                            'enter':_cityFieldController.text
                          }
                          );
                        },
                        textColor: Colors.white,
                        color: Colors.redAccent,
                        child: Text('Checkout Weather')
                    )

                  )
                ],
              )
            ]

          )
        ],
      ),
    );
  }
}

