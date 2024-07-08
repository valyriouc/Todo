import 'package:flutter/material.dart';
import 'package:pokemin/data/pokemon.dart';
import 'package:pokemin/views/pokemonListView.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ListProviderViewModel>(create: (context) => ListProviderViewModel())
      ], 
      child: const MainApp()
      )
    );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Pokemin"),
        ),
        body: const   PokemonListView(),
      ),
    );
  }
}
