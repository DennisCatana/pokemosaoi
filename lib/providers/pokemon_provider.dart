import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/api_services.dart';

class PokemonProvider with ChangeNotifier {
  final ApiServices _apiService = ApiServices();
  List<Pokemon> _pokemonList = [];
  bool _isLoading = false;

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;

  Future<void> fetchPokemon() async {
    _isLoading = true;
    notifyListeners();

    _pokemonList = await _apiService.fetchPokemonList();
    _isLoading = false;
    notifyListeners();
  }
}
