import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class WeatherService {

  final String apiKey = dotenv.env['WEATHER_API_KEY']??''; 
  final String city = 'Pamekasan'; 

Future<Map<String, dynamic>> getCurrentWeather() async {
    // Validasi 
    if (apiKey.isEmpty) {
      throw Exception('API Key tidak ditemukan. Pastikan .env sudah dikonfigurasi dengan benar.');
    }
    
    // Membuat URL untuk meminta data cuaca
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=id');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 401) {
        throw Exception('API Key tidak valid atau salah. Mohon periksa kembali.');
      }
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Server error: ${response.body}');
        throw Exception('Gagal memuat data cuaca. Status code: ${response.statusCode}');
      }
    } catch (e) {
      
      rethrow; 
    }
  }
}