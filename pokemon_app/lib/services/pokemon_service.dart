import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pokemon.dart';

class PokemonService {
  static const int _totalPokemon = 1010;
  static const int _pageSize = 30;
  static const String _cacheKeyPrefix = 'pokemon_page_';

  /// Fetches Pokemon with pagination support
  Future<(List<Pokemon>, bool)> getPokemon({int offset = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cacheKeyPrefix$offset';
    final url =
        'https://pokeapi.co/api/v2/pokemon?limit=$_pageSize&offset=$offset';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        await prefs.setString(cacheKey, response.body);
        return (_parseJson(response.body), false);
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        return (_parseJson(cachedData), true);
      }
      rethrow;
    }
  }

  /// Fetches random Pokemon for refresh functionality
  Future<(List<Pokemon>, bool)> getRandomPokemon({int count = 50}) async {
    final prefs = await SharedPreferences.getInstance();
    const cacheKey = 'random_pokemon_cache';

    try {
      final random = Random();
      final List<Pokemon> allPokemon = [];
      final Set<int> usedOffsets = {};

      while (allPokemon.length < count &&
          usedOffsets.length < (_totalPokemon ~/ _pageSize)) {
        final offset = (random.nextInt(_totalPokemon ~/ _pageSize)) * _pageSize;

        if (usedOffsets.contains(offset)) continue;
        usedOffsets.add(offset);

        final url =
            'https://pokeapi.co/api/v2/pokemon?limit=$_pageSize&offset=$offset';
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final pokemon = _parseJson(response.body);
          allPokemon.addAll(pokemon);
        }
      }

      allPokemon.shuffle();
      final result = allPokemon.take(count).toList();

      final jsonData = json.encode({
        'results': result.map((p) => p.toJson()).toList(),
      });
      await prefs.setString(cacheKey, jsonData);

      return (result, false);
    } catch (e) {
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        return (_parseJson(cachedData), true);
      }
      rethrow;
    }
  }

  int get totalPokemon => _totalPokemon;
  int get pageSize => _pageSize;

  /// Fetches detailed information for a specific Pokemon by ID
  Future<Map<String, dynamic>> getPokemonDetails(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'pokemon_details_$id';

    try {
      // Try fetching from API
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'),
      );

      if (response.statusCode == 200) {
        // Cache the response
        await prefs.setString(cacheKey, response.body);
        return json.decode(response.body);
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      // Try to load from cache
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        return json.decode(cachedData);
      }
      rethrow;
    }
  }

  List<Pokemon> _parseJson(String jsonString) {
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final response = PokemonResponse.fromJson(jsonMap);
    return response.results;
  }
}
