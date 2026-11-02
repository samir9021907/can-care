import 'package:flutter/material.dart';

class ForecastDay {
  final String dayNameKey; // e.g., 'forecast_today', 'forecast_tomorrow', 'day_sun', 'day_mon'
  final String fallbackDayName;
  final int highTemp;
  final int lowTemp;
  final IconData icon;

  const ForecastDay({
    required this.dayNameKey,
    required this.fallbackDayName,
    required this.highTemp,
    required this.lowTemp,
    this.icon = Icons.wb_cloudy_rounded,
  });
}

class WeatherData {
  final String location;
  final int currentTemp;
  final String conditionKey;
  final String fallbackCondition;
  final int humidity;
  final int windSpeedKmh;
  final List<ForecastDay> dailyForecast;
  final String cropAdvice;
  final double? latitude;
  final double? longitude;
  final bool isLiveGps;

  const WeatherData({
    required this.location,
    required this.currentTemp,
    required this.conditionKey,
    required this.fallbackCondition,
    required this.humidity,
    required this.windSpeedKmh,
    required this.dailyForecast,
    required this.cropAdvice,
    this.latitude,
    this.longitude,
    this.isLiveGps = false,
  });
}

class TownLocation {
  final String nameMr;
  final String nameHi;
  final String nameEn;
  final String districtMr;
  final String districtEn;
  final double latitude;
  final double longitude;

  const TownLocation({
    required this.nameMr,
    required this.nameHi,
    required this.nameEn,
    required this.districtMr,
    required this.districtEn,
    required this.latitude,
    required this.longitude,
  });

  String displayName(String langCode) {
    if (langCode == 'mr') return '$nameMr, $districtMr';
    if (langCode == 'hi') return '$nameHi, $districtEn';
    return '$nameEn, $districtEn';
  }
}

abstract class WeatherService {
  Future<WeatherData> fetchWeatherForLocation(String location);
  List<String> getAvailableLocations();
  Future<WeatherData> fetchWeatherForCoordinates(
    double lat,
    double lon, {
    String? locationName,
    bool isLiveGps = false,
  });
}
