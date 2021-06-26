import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart'as http;


class Weather extends StatefulWidget {
  static const String id = 'Weather';
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {

  var temp ;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var visibility;

  Future getWeatherInfo ()async {
    http.Response response = await http.get('http://api.openweathermap.org/data/2.5/weather?q=Islamabad&units=metric&appid=0437d87a63a252bcfeadc3cb929537f4');
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently= results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.visibility = results['visibility'];

    });
  }
  @override
  void initState(){
    super.initState();
    this.getWeatherInfo();
  }





  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/3,
                width: MediaQuery.of(context).size.width,
                color: Color(0xff45736A),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(""
                          "Currently in Islamabad ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,

                      )
                        ,),

                    ),

                    Text(
                      temp != null ? temp.toString()+"\u00B0": "Loading",
                      style:TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w600,

                      ) ,
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                          currently != null ? currently.toString():"Loading",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,

                        )
                        ,),

                    ),
                  ],
                ),
              ),

              Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ListView(
                      children:<Widget> [

                        ListTile(
                          leading:FaIcon(FontAwesomeIcons.thermometerHalf) ,
                          title: Text("Temperature"),
                          trailing: Text(temp != null ? temp.toString()+"\u00B0": "Loading",),
                        ),

                        ListTile(
                          leading:FaIcon(FontAwesomeIcons.cloud) ,
                          title: Text("Weather"),
                          trailing: Text(description != null ? description.toString():"Loading",),
                        ),

                        ListTile(
                          leading:FaIcon(FontAwesomeIcons.sun) ,
                          title: Text("Humidity"),
                          trailing: Text(humidity != null ? humidity.toString():"Loading",),
                        ),

                        ListTile(
                          leading:FaIcon(FontAwesomeIcons.wind) ,
                          title: Text("Wind Speed"),
                          trailing: Text(windSpeed != null ? windSpeed.toString():"Loading",),
                        ),

                        ListTile(
                          leading:FaIcon(FontAwesomeIcons.eye) ,
                          title: Text("Visibility"),
                          trailing: Text(visibility != null ? visibility.toString():"Loading",),
                        ),




                      ],
                    ),
                  )
              )
            ],
          ),
        )

    );
  }
}
