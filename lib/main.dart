import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../services/api_services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PokemonProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter PokeAPI Demo',
        home: PokemonListScreen(),
      ),
    );
  }
}

class PokemonListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon List'),
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: provider.pokemonList.length,
            itemBuilder: (context, index) {
              Pokemon pokemon = provider.pokemonList[index];
              return ListTile(
                title: Text(pokemon.name),
                onTap: () {
                  // Puedes agregar una navegación a un detalle de Pokémon aquí
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<PokemonProvider>(context, listen: false).fetchPokemon();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

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
