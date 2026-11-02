import 'package:flutter/material.dart';
import 'weather_service.dart';

class DemoWeatherService implements WeatherService {
  static const List<String> maharashtraDistricts = [
    'सातारा, महाराष्ट्र',
    'कोल्हापूर, महाराष्ट्र',
    'सांगली, महाराष्ट्र',
    'पुणे, महाराष्ट्र',
    'सोलापूर, महाराष्ट्र',
    'अहमदनगर, महाराष्ट्र',
  ];

  @override
  List<String> getAvailableLocations() => maharashtraDistricts;

  @override
  Future<WeatherData> fetchWeatherForLocation(String location) async {
    // Simulated short network delay for responsive frontend demo
    await Future.delayed(const Duration(milliseconds: 350));

    // Temperature slight variation by location
    int baseTemp = 28;
    if (location.contains('कोल्हापूर')) {
      baseTemp = 29;
    } else if (location.contains('पुणे')) {
      baseTemp = 27;
    } else if (location.contains('सोलापूर')) {
      baseTemp = 32;
    }

    return WeatherData(
      location: location,
      currentTemp: baseTemp,
      conditionKey: 'weather_partly_cloudy',
      fallbackCondition: 'अंशतः ढगाळ',
      humidity: 72,
      windSpeedKmh: 12,
      dailyForecast: [
        ForecastDay(
          dayNameKey: 'forecast_today',
          fallbackDayName: 'आज',
          highTemp: baseTemp,
          lowTemp: baseTemp - 6,
          icon: Icons.wb_cloudy_rounded,
        ),
        ForecastDay(
          dayNameKey: 'forecast_tomorrow',
          fallbackDayName: 'उद्या',
          highTemp: baseTemp - 1,
          lowTemp: baseTemp - 7,
          icon: Icons.wb_cloudy_rounded,
        ),
        ForecastDay(
          dayNameKey: 'day_sun',
          fallbackDayName: 'रवि',
          highTemp: baseTemp - 2,
          lowTemp: baseTemp - 8,
          icon: Icons.wb_cloudy_rounded,
        ),
        ForecastDay(
          dayNameKey: 'day_mon',
          fallbackDayName: 'सोम',
          highTemp: baseTemp - 3,
          lowTemp: baseTemp - 9,
          icon: Icons.wb_cloudy_rounded,
        ),
      ],
      cropAdvice: 'आज हवामान अनुकूल आहे. पाण्याचे व्यवस्थापन योग्य ठेवा.',
    );
  }

  @override
  Future<WeatherData> fetchWeatherForCoordinates(
    double lat,
    double lon, {
    String? locationName,
    bool isLiveGps = false,
  }) async {
    final weather = await fetchWeatherForLocation(locationName ?? 'सातारा, महाराष्ट्र');
    return WeatherData(
      location: locationName ?? weather.location,
      currentTemp: weather.currentTemp,
      conditionKey: weather.conditionKey,
      fallbackCondition: weather.fallbackCondition,
      humidity: weather.humidity,
      windSpeedKmh: weather.windSpeedKmh,
      dailyForecast: weather.dailyForecast,
      cropAdvice: weather.cropAdvice,
      latitude: lat,
      longitude: lon,
      isLiveGps: isLiveGps,
    );
  }
}

