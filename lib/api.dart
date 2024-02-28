import 'dart:convert';

import 'package:weather_application/constants.dart';
import 'package:http/http.dart' as http;
import 'package:weather_application/weathermodal.dart';

class WeatherApi{
  final String baseUrl = "http://api.weatherapi.com/v1/current.json";

  Future<ApiResponse> getCurrentWeather(String location) async{
    String apiUrl = "$baseUrl?key=$apiKey&q=$location";

    try{
      final response = await http.get(Uri.parse(apiUrl));
      if(response.statusCode == 200){
        return ApiResponse.fromJson(jsonDecode(response.body));
      }
      else{
        throw Exception("failed to load weather");
      }
    }
    catch(e){
      throw Exception("failed to load weather");
    }
  }
}