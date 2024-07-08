import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiServices {
  final String baseUrl = "https://pokeapi.co/api/v2";

  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=10'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((e) => Pokemon.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Pokemon API');
    }
  }
}
