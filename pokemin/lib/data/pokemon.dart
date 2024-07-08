
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokemin/views/pokemonListView.dart';

class PokemonSprites {
  String? back_default;
  String? back_female;
  String? back_shiny;
  String? back_shiny_female;
  String? front_default;
  String? front_female;
  String? front_shiny;
  String? front_shiny_female;
}

class Pokemon {
  int id = -1;
  bool isDefault = true;
  int height = -1;
  int weight = -1;

  // PokemonSprites sprites;

  static Future init() async {

  }
}

class PokemonItem {
  String name;
  String url;

  PokemonItem({required this.name, required this.url});
}

class PokemonsModelView {

  Uri _uri;

  late int _count;
  late String? _next;
  late String? _previous;
  final List<PokemonItem> _results = <PokemonItem>[];

  PokemonsModelView.fromOffset(int offset, int limit) 
    : _uri = Uri(scheme: "https", host: "pokeapi.co", path: "/api/v2/pokemon/", query: "offset=$offset&limit=$limit");

  PokemonsModelView.fromPath({required String path}) : _uri = Uri(scheme: "https", host: "pokeapi", path: path);
  
  Future fromApiAsync() async {
    http.Response res = await http.get(this._uri);

    dynamic obj = jsonDecode(res.body);
    
    // _count = int.parse(obj["count"]);
    _next = obj["next"];
    _previous = obj["previous"];

    for (dynamic item in obj["results"]) {
      _results.add(PokemonItem(name: item["name"], url: item["url"]));
    }

    return;
  }

  Future<PokemonsModelView?> nextAsync() async {
    if (this.next == null) {
      return null;
    }

    String next = this.next!.replaceFirst("https://pokeapi.co", "");
    PokemonsModelView view = PokemonsModelView.fromPath(path: next);

    await view.fromApiAsync();

    return view;
  }

  Future<PokemonsModelView?> previousAsync() async {
    if (this.previous == null) {
      return null;
    }

    String previous = this.previous!.replaceFirst("https://pokeapi.co", "");
    PokemonsModelView view = PokemonsModelView.fromPath(path: previous);

    await view.fromApiAsync();

    return view;
  }

  int get count => _count;
  String? get next => _next;
  String? get previous => _previous;
  List<PokemonItem> get results => _results;
}

class ListProviderViewModel extends ChangeNotifier {
  
  PokemonsModelView? previous = null;
  PokemonsModelView current = PokemonsModelView.fromOffset(0, 20);
  PokemonsModelView? next = null;

  Future toNextAsync() async {
    if (this.next != null) {
      PokemonsModelView next = this.next!;
      previous = current;
      current = next;
    } else {
      PokemonsModelView? now = await current.nextAsync();
      if (now != null) {
        previous = current;
        current = now;
      }
    }
    notifyListeners();
  }

  Future toPreviousAsync() async {
    if (this.previous != null) {
      PokemonsModelView prev = this.previous!;
      next = current;
      current = prev;
    } else {
      PokemonsModelView? now = await current.previousAsync();
      if (now != null) {
        next = current;
        current = now;
      }
    }

    notifyListeners();
  }
}