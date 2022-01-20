import 'package:coolet/services/weather.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';

import 'main_screen.dart';

class HomePage extends StatefulWidget {
  static const String route = 'home';
  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  Future getLocationData() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorWidget(),
          ));
    }
  }

  Future getData() async {
    WeatherModel weather = WeatherModel();
    var data = await weather.getLocationWeather();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            weatherData: data,
          ),
        ),
        (route) => false);
  }

  @override
  void initState() {
    getLocationData();
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SpinKitDoubleBounce(
        color: Colors.black,
        size: 100.0,
      )),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("¯\\_(ツ)_/¯", style: TextStyle(fontSize: 38)),
            SizedBox(height: 10),
            Text(
              "Come on...You know I can't help you with your device location off.\n Try again with your location on...",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () async {
                bool location = await Geolocator.isLocationServiceEnabled();
                if (location) {
                  Navigator.pushNamed(context, HomePage.route);
                }
              },
              child: Text(
                'Retry again',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
