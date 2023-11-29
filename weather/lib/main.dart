import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LiveWeatherPage(),
        '/city': (context) => const AllCityInfoPage(),
      },
    );
  }
}

class LiveWeatherPage extends StatefulWidget {
  const LiveWeatherPage({Key? key}) : super(key: key);

  @override
  _LiveWeatherPageState createState() => _LiveWeatherPageState();
}

class _LiveWeatherPageState extends State<LiveWeatherPage> {
  String apiKey = '8a6210d87373c4a873bfb7ad05efbbb9';
  String weatherInfo = 'Press the button to get live weather';


  Future<void> getLiveWeather() async {
    LocationData? locationData;
    var location = Location();

    try {
      locationData = await location.getLocation();
    } catch (e) {
      print('Error getting location: $e');
    }

    if (locationData != null) {
      final response = await http.get(
        Uri.parse(
            'http://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          weatherInfo =
          'Temperature: ${data['main']['temp']}°C\nWeather: ${data['weather'][0]['main']}';
        });
      } else {
        throw Exception('Failed to load weather information');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Weather',style: TextStyle(
          fontWeight: FontWeight.w500
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            /// Live Output
            Container(
              alignment: Alignment.center,
              height: 150,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12)
              ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Live Weather ',style: TextStyle(
                      fontWeight: FontWeight.w500,fontSize: 20
                    )),
                    const Divider(color: Colors.black12,endIndent: 20,indent: 20),
                    const SizedBox(height: 10,),
                    Text(weatherInfo),
                  ],
                )
            ),
            const SizedBox(height: 15,),
            /// Get Live Weather
            InkWell(
              onTap: getLiveWeather,
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: const Text('Get Live Weather',style: TextStyle(
                  color: Colors.white,
                )),
              ),
            ),
            // ElevatedButton(
            //   onPressed: getLiveWeather,
            //   child: const Text('Get Live Weather'),
            // ),
             const SizedBox(height: 20,),

            /// Go To All City Info
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/city');
              },
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: const Text('Go to All City Info',style: TextStyle(
                  color: Colors.white,
                )),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/city');
            //   },
            //   child: const Text('Go to All City Info'),
            // ),
          ],
        ),
      ),
    );
  }
}

class AllCityInfoPage extends StatefulWidget {
  const AllCityInfoPage({Key? key}) : super(key: key);

  @override
  _AllCityInfoPageState createState() => _AllCityInfoPageState();
}

class _AllCityInfoPageState extends State<AllCityInfoPage> {
  String apiKey = '8a6210d87373c4a873bfb7ad05efbbb9';
  String cityInfo = 'Select a city to get information';

  String dropDownValue = 'None';

  Future<void> getCityInfo(String cityName) async {
    final response = await http.get(
      Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        cityInfo = 'City: $cityName\nTemperature: ${data['main']['temp']}°C\nWeather: ${data['weather'][0]['main']}';
      });
    } else {
      throw Exception('Failed to load city information');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All City Information'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(' City Weather ',style: TextStyle(
                        fontWeight: FontWeight.w500,fontSize: 20
                    )),
                   const Divider(color: Colors.black12,endIndent: 20,indent: 20),
                  const  SizedBox(height: 10,),
                    Text(cityInfo),
                  ],
                )
            ),
            const SizedBox(height: 15,),
            // Text(cityInfo),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10)
              ),
              child: DropdownButton<String>(
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(10),
                value: dropDownValue,
                onChanged: (value) {
                  setState(() {
                    dropDownValue = value!;
                  });
                  getCityInfo(value!);
                },
                items: [
                  // none
                  'None',

                  // Uttar Pradesh
                  'Lucknow', 'Kanpur', 'Agra', 'Varanasi',

                  // Maharashtra
                  'Mumbai', 'Pune', 'Nagpur', 'Nashik',

                  // Karnataka
                  'Bangalore', 'Mysore', 'Hubli', 'Mangalore',

                  // Tamil Nadu
                  'Chennai', 'Coimbatore', 'Madurai', 'Trichy',

                  // Gujarat
                  'Ahmedabad', 'Surat', 'Vadodara', 'Rajkot',

                  // West Bengal
                  'Kolkata', 'Howrah', 'Durgapur', 'Asansol',

                  // Rajasthan
                  'Jaipur', 'Jodhpur', 'Udaipur', 'Kota',

                  // Kerala
                  'Thiruvananthapuram', 'Kochi', 'Kozhikode', 'Thrissur',

                  // Punjab
                  'Amritsar', 'Ludhiana', 'Jalandhar', 'Patiala',

                  // Andhra Pradesh
                  'Hyderabad', 'Visakhapatnam', 'Vijayawada', 'Guntur',

                  // Telangana
                  'Warangal', 'Nizamabad', 'Karimnagar', 'Khammam',

                  // Odisha
                  'Bhubaneswar', 'Cuttack', 'Rourkela', 'Puri',

                  // Bihar
                  'Patna', 'Gaya', 'Muzaffarpur', 'Bhagalpur',

                  // Madhya Pradesh
                  'Indore', 'Bhopal', 'Jabalpur', 'Gwalior',

                  // Haryana
                  'Gurgaon', 'Faridabad', 'Panipat', 'Ambala',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 50,),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: const Text('Back to Live Weather',style: TextStyle(
                  color: Colors.white,
                )),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   child: const Text('Back to Live Weather'),
            // ),
          ],
        ),
      ),
    );
  }
}