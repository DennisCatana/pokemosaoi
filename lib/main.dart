import 'package:flutter/material.dart';
import 'package:pokemosaoi/models/pokemon.dart';
import 'package:provider/provider.dart';
import './providers/pokemon_provider.dart';
import './services/cats_services.dart';

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
        title: 'Flutter API Demo',
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PokemonListScreen(),
    CatListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumo de API'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Pokémons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Gatos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class PokemonListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: provider.pokemonList.length,
            itemBuilder: (context, index) {
              Pokemon pokemon =
                  provider.pokemonList[index]; // Aquí usamos la clase Pokemon
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

class CatListScreen extends StatefulWidget {
  @override
  _CatListScreenState createState() => _CatListScreenState();
}

class _CatListScreenState extends State<CatListScreen> {
  final CatService _catService = CatService();
  Future<List<String>>? _futureCatImages;

  @override
  void initState() {
    super.initState();
    _futureCatImages = _catService.fetchCatImages(
        width: 300, height: 300); // Ajusta el ancho y alto según sea necesario
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _futureCatImages,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No cats found'));
        } else {
          // Solo muestra las dos primeras imágenes
          List<String> catImages = snapshot.data!.take(5).toList();
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: catImages.map((imageUrl) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  child: Image.network(
                    imageUrl,
                    width: 200, // Ancho fijo
                    height: 200, // Alto fijo
                    fit: BoxFit
                        .cover, // Ajusta la imagen para cubrir todo el espacio disponible sin cortarse
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
