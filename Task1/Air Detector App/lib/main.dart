import 'dart:convert';
import 'package:air_pollution_app/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class AirQualityPage extends StatefulWidget {
  const AirQualityPage({super.key});

  @override
  State<AirQualityPage> createState() => _AirQualityPageState();
}

class _AirQualityPageState extends State<AirQualityPage> {
  bool loading = false;
  Map<String, dynamic>? pollutionData;

  final String apiKey = "d01e088845dd77a6eff778b4251a06e9";

  /// ---------------- LOCATION + API ----------------
  Future<void> getAirQuality() async {
    setState(() => loading = true);

    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final url =
        "http://api.openweathermap.org/data/2.5/air_pollution?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    setState(() {
      pollutionData = data["list"][0]["components"];
      loading = false;
    });
  }

  /// ---------------- QUALITY LOGIC ----------------
  String getQuality(String key, double v) {
    switch (key) {
      case "pm2_5":
        return v < 10
            ? "Good"
            : v < 25
            ? "Fair"
            : v < 50
            ? "Moderate"
            : v < 75
            ? "Poor"
            : "Very Poor";
      case "pm10":
        return v < 20
            ? "Good"
            : v < 50
            ? "Fair"
            : v < 100
            ? "Moderate"
            : v < 200
            ? "Poor"
            : "Very Poor";
      case "so2":
        return v < 20
            ? "Good"
            : v < 80
            ? "Fair"
            : v < 250
            ? "Moderate"
            : v < 350
            ? "Poor"
            : "Very Poor";
      case "no2":
        return v < 40
            ? "Good"
            : v < 70
            ? "Fair"
            : v < 150
            ? "Moderate"
            : v < 200
            ? "Poor"
            : "Very Poor";
      case "o3":
        return v < 60
            ? "Good"
            : v < 100
            ? "Fair"
            : v < 140
            ? "Moderate"
            : v < 180
            ? "Poor"
            : "Very Poor";
      case "co":
        return v < 4400
            ? "Good"
            : v < 9400
            ? "Fair"
            : v < 12400
            ? "Moderate"
            : v < 15400
            ? "Poor"
            : "Very Poor";
    }
    return "-";
  }

  Color statusColor(String status) {
    switch (status) {
      case "Good":
        return Colors.greenAccent;
      case "Fair":
        return Colors.lightGreen;
      case "Moderate":
        return Colors.orangeAccent;
      case "Poor":
        return Colors.deepOrange;
      default:
        return Colors.redAccent;
    }
  }

  /// ---------------- UI TILE ----------------
  Widget pollutionTile(String name, String key, String emoji) {
    double value = pollutionData![key].toDouble();
    String status = getQuality(key, value);
    Color color = statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(.4), color.withOpacity(.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "$status • ${value.toStringAsFixed(1)} μg/m³",
                style: TextStyle(color: Colors.white.withOpacity(.8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- MAIN UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              loading
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : pollutionData == null
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "🌍 Air Quality Checker",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: getAirQuality,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            "Check My Air 🌬️",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  )
                  : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "🌍 Air Quality Near You",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        pollutionTile("PM2.5", "pm2_5", "😷"),
                        pollutionTile("PM10", "pm10", "🌫️"),
                        pollutionTile("SO₂", "so2", "🌿"),
                        pollutionTile("NO₂", "no2", "🔥"),
                        pollutionTile("O₃", "o3", "🌤️"),
                        pollutionTile("CO", "co", "🚗"),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
