import 'package:clima/Controllers/LocationController.dart';
import 'package:clima/Controllers/NetworkController.dart';
import 'package:clima/Utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Position position;
  bool isLoading = true;
  late double temprature;
  late String condition;
  late int conditionId;
  late String description;
  late String city;
  late DateTime sunset;
  late DateTime sunrise;
  void getLocation() async {
    LocationController locationController = LocationController();
    try {
      position = await locationController.getPosition();
      print(position);
      NetworkController networkController = NetworkController(
          url:
              'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=a8c9f2d0c5b21cf9f344ff58e8cabe42&units=metric');
      var data = await networkController.getWeather();

      if (data != null) {
        print(data);
        setState(() {
          isLoading = false;
          temprature = data['main']['temp'];
          condition = data['weather'][0]['icon'];
          conditionId = data['weather'][0]['id'];
          description = data['weather'][0]['description'];
          city = data['name'];
          sunrise = DateTime.fromMillisecondsSinceEpoch(
              data['sys']['sunrise'] * 1000,
              isUtc: true);
          sunset = DateTime.fromMillisecondsSinceEpoch(
              data['sys']['sunset'] * 1000,
              isUtc: true);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: isLoading
              ? Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.white,
                    size: 300,
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.network(
                        'https://openweathermap.org/img/wn/$condition@4x.png',
                        scale: .8,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              temprature.toStringAsFixed(0),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 150,
                                  fontWeight: FontWeight.bold),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'O',
                                  style: TextStyle(
                                    fontSize: 50,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'now',
                                  style: TextStyle(
                                      fontSize: 50,
                                      color: Colors.white,
                                      letterSpacing: 10),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Text(
                        'Grab ${getEmoji(conditionId)}',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "It's $description in $city",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 50,
                                offset: Offset(0, 25),
                                color: Colors.white24,
                              )
                            ],
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Sunrise on',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          DateFormat.jm()
                                              .format(sunrise.toLocal()),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(
                                    width: 15.0,
                                    thickness: 1.0,
                                    color: Colors.black,
                                  ),
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat.jm()
                                              .format(sunset.toLocal()),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          'Sunset on',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                )),
    );
  }
}
