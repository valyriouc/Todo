import 'package:flutter/material.dart';
import 'package:pokemin/data/pokemon.dart';
import 'package:provider/provider.dart';

class PokemonListView extends StatelessWidget {
  const PokemonListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ListProviderViewModel>(
      builder: (context, viewModel, test) {
        viewModel.current.fromApiAsync().then((value) => {},);
        return ListView.builder(
          itemCount: viewModel.current.results.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(viewModel.current.results[index].name));
          }
        );
      },
    );
  }
}