// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pokemon _$PokemonFromJson(Map<String, dynamic> json) =>
    Pokemon(name: json['name'] as String, url: json['url'] as String);

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
  'name': instance.name,
  'url': instance.url,
};

PokemonResponse _$PokemonResponseFromJson(Map<String, dynamic> json) =>
    PokemonResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PokemonResponseToJson(PokemonResponse instance) =>
    <String, dynamic>{'results': instance.results};
