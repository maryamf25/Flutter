import 'package:json_annotation/json_annotation.dart';

part 'pokemon.g.dart';

@JsonSerializable()
class Pokemon {
  final String name;
  final String url;

  Pokemon({required this.name, required this.url});

  // Derived property: Extract ID from URL to get the image
  int get id {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return int.parse(segments.last);
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);
  Map<String, dynamic> toJson() => _$PokemonToJson(this);
}

@JsonSerializable()
class PokemonResponse {
  final List<Pokemon> results;

  PokemonResponse({required this.results});

  factory PokemonResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PokemonResponseToJson(this);
}
