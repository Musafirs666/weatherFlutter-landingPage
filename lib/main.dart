import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_flutterapp/custom_widget/LongForecastDesc.dart';
import 'package:weather_flutterapp/custom_widget/SquareForecastDesc.dart';
import 'custom_widget/NavbarIcon.dart';
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> _currentForecastData = {};
  List<dynamic> _todayForecastData = [];
  bool _isLoading = true;
  String _timeOfDay = "";
  String _currentDateTime = "";
  final ScrollController _scrollController = ScrollController();
  String _currentHour = "";
  String _formattedCondition = "";

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi untuk mengambil data dari API saat widget pertama kali dibuat
    fetchData();
  }

  Future<void> fetchData() async {

    //load file .env
    await dotenv.load();

    final response = await http.get(Uri.parse('${dotenv.env['BASE_URL']}?key=${dotenv.env['API_KEY']}&q=Jakarta&days=1&aqi=no&alerts=no'));

    // Memeriksa apakah panggilan API berhasil
    if (response.statusCode == 200) {
      setState(() {
        _currentForecastData = json.decode(response.body);
        _todayForecastData =
            json.decode(response.body)['forecast']['forecastday'][0]['hour'];

        List<String> currentTimes =
            _currentForecastData['location']['localtime'].split(' ');
        String currentTime = currentTimes[1];
        int currentHour = int.parse(currentTime.split(':')[0]);
        _currentHour = currentHour.toString();
        if (currentHour >= 0 && currentHour < 12) {
          _timeOfDay = 'morning';
        } else if (currentHour >= 12 && currentHour < 18) {
          _timeOfDay = 'midday';
        } else {
          _timeOfDay = 'tonight';
        }
      });

      _currentDateTime  = _currentForecastData['location']['localtime'];
      String conditionText = _currentForecastData['current']['condition']['text'].toString();

      if (conditionText.split(" ").length > 1) {
        _formattedCondition = conditionText.split(" ")[1].toUpperCase();
      } else {
        _formattedCondition = conditionText.toUpperCase();
      }

      _isLoading = false;
      int activeIndex = _todayForecastData.indexWhere((hourData) {
        List<String> dateTimeParts = hourData['time'].split(' ');
        String time = dateTimeParts[1]; // Format: HH:MM
        String hour = time.split(':')[0];

        return hour == _currentHour;
      });
      if (activeIndex != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Hitung posisi scroll agar elemen aktif berada di tengah layar
          double screenWidth = MediaQuery.of(context).size.width;
          double itemWidth = 90;
          double scrollPosition =
              (activeIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
          _scrollController.jumpTo(scrollPosition);
        });
      }
    } else {
      // Jika gagal, kita mencetak pesan error
      // print('Failed to load data: ${response.statusCode}');
    }
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    double scaleFactor = screenWidth / 400;

    return Scaffold(
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.waveDots(
              color: const Color(0xFFAECDFF),
              size: 75,
            ))
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                    child: Column(
                      children: [
                        SafeArea(
                            child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(children: [
                                  NavbarIcon(
                                    icon: Icons.menu_rounded,
                                    onTap: () {},
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  NavbarIcon(
                                    icon: Icons.location_pin,
                                    onTap: () {},
                                  )
                                ]),
                              ),
                              NavbarIcon(
                                icon: Icons.person,
                                onTap: () {},
                              )
                            ],
                          ),
                        )),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_currentForecastData['location']['name'].toUpperCase()}",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: "Poppins",
                                        height: 1.3,
                                        letterSpacing: 0,
                                        color: const Color(0xFF2D3039),
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.grey.withOpacity(0.25),
                                            blurRadius: 20,
                                            offset: const Offset(2.5, 3),
                                          ),
                                        ],
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "${_currentForecastData['location']['country']}",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontFamily: "Poppins",
                                        color: const Color(0xFF2D3039),
                                        height: 1.3,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.grey.withOpacity(0.25),
                                            blurRadius: 20,
                                            offset: const Offset(2.5, 3),
                                          ),
                                        ],
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    _currentDateTime,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                        height: 2,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 30),
                       Container(
                         width: screenWidth,
                         height: 225,
                         margin: const EdgeInsets.fromLTRB(30, 30, 30, 20),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(35),
                             boxShadow: [
                               BoxShadow(
                                 color:
                                 const Color(0xFFAECDFF).withOpacity(1),
                                 blurRadius: 20,
                                 spreadRadius: 2,
                                 offset: const Offset(2.5, 10),
                               ),
                             ],
                             gradient: const LinearGradient(
                               colors: [
                                 Color(
                                     0xFFAECDFF), // Warna gradient dari atas
                                 Color(
                                     0xFF5896FD), // Warna gradient ke bawah
                               ],
                               begin: Alignment.topCenter,
                               end: Alignment.bottomCenter,
                             )),
                         child:Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Padding(
                               padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Container(
                                     width: screenWidth/3,
                                     height: screenWidth/3,
                                     decoration: BoxDecoration(
                                       image: DecorationImage(
                                         // image: AssetImage('assets/rainy_icon.png'),
                                         image: NetworkImage("https:${_currentForecastData['current']['condition']['icon']}"),
                                         fit: BoxFit.contain,
                                       ),
                                       borderRadius: BorderRadius.circular(10),
                                     ),
                                   ),
                                   Text(
                                     _formattedCondition,
                                     style: TextStyle(
                                         fontSize: 30 * scaleFactor,
                                         color: Colors.white,
                                         letterSpacing: 0,
                                         height: 1,
                                         fontFamily: "Poppins",
                                         fontWeight: FontWeight.w700),
                                   ),
                                   Text(
                                     _timeOfDay,
                                     style: const TextStyle(
                                         fontSize: 17,
                                         color: Colors.white,
                                         height: 2.5,
                                         fontFamily: "ITC",
                                         fontWeight: FontWeight.w600),
                                   )
                                 ],
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 children: [
                                   Row(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       ShaderMask(
                                         shaderCallback: (Rect bounds) {
                                           return const LinearGradient(
                                             colors: [
                                               Colors.white,
                                               Color(0xFFAECDFF),
                                             ],
                                             begin: Alignment.topCenter,
                                             end: Alignment.bottomCenter,
                                             stops: [0.0, 1.0],
                                           ).createShader(bounds);
                                         },
                                         child: Text(
                                           "${_currentForecastData['current']['temp_c'].toStringAsFixed(0)}",
                                           style: TextStyle(
                                               color: Colors.white,
                                               fontSize: 80 * scaleFactor,
                                               fontFamily: "Poppins",
                                               fontWeight: FontWeight.w600,
                                               height: 1),
                                         ),
                                       ),
                                       const Text(
                                         "°",
                                         style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 40,
                                             fontFamily: "Poppins",
                                             fontWeight: FontWeight.w600,
                                             height: 1),
                                       ),
                                     ],
                                   ),
                                   Text(
                                     "Feels like${_currentForecastData['current']['feelslike_c'].toStringAsFixed(0)} °",
                                     style: const TextStyle(
                                       color: Colors.white,
                                       fontSize: 15,
                                       fontFamily: "ITC",
                                       height: 1,
                                       fontWeight: FontWeight.w600,
                                     ),
                                   ),
                                 ],
                               ),
                             )
                           ],
                         ),
                       ),
                        // const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SquareForecastDesc(
                              text:
                                  "${_currentForecastData['current']['wind_kph'].toStringAsFixed(0)} kph",
                              image: Image.asset("assets/windSpeed.png"),
                            ),
                            SquareForecastDesc(
                              text:
                                  "${_currentForecastData['current']['cloud'].toStringAsFixed(0)}%",
                              image: Image.asset("assets/cloud.png"),
                            ),
                            SquareForecastDesc(
                              text:
                                  "${_currentForecastData['current']['wind_dir']}",
                              image: Image.asset("assets/windDirection.png"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Today",
                                style: TextStyle(
                                    color: Color(0xFF2D3039),
                                    fontSize: 25,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Next 7 Days >",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'ITC',
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5896FD)),
                              )
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: _todayForecastData.map((hourData) {
                              List<String> dateTimeParts =
                                  hourData['time'].split(' ');

                              // Mengambil bagian jam dari hasil pemisahan
                              String time = dateTimeParts[1]; // Format: HH:MM
                              String hour = time.split(':')[
                                  0]; // Mengambil jam saja dari hasil pemisahan

                              return LongForecastDesc(
                                image: Image.network(
                                    "https:${_currentForecastData['current']['condition']['icon']}"),
                                textDesc:
                                    "${hourData['temp_c'].toStringAsFixed(0)}°", // Anda dapat mengambil nilai ini dari data jam cuaca jika ada
                                textHour:
                                    time, // Ambil waktu dari data jam cuaca
                                isActive: hour ==
                                    _currentHour, // Tergantung pada logika aplikasi Anda
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
