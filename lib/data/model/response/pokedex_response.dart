// To parse this JSON data, do
//
//     final responsePokedex = responsePokedexfromMap(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../domain/entity/character_pokedex_entity.dart';

ResponsePokedex responsePokedexfromMap(String str) =>
    ResponsePokedex.fromMap(json.decode(str));

String responsePokedextoMap(ResponsePokedex data) => json.encode(data.toMap());
converterDynamicMap(dynamic data) {
  Map<String, dynamic> mapaConvertido = {};

  data.forEach((key, value) {
    mapaConvertido[key.toString()] = value;
  });

  return mapaConvertido;
}

class ResponsePokedex with EquatableMixin  {
  final List<Description> descriptions;
  final int id;
  final bool isMainSeries;
  final String name;
  final List<Name> names;
  final List<PokemonEntry> pokemonEntries;
  final Region? region;
  final List<Region> versionGroups;

  ResponsePokedex({
    required this.descriptions,
    required this.id,
    required this.isMainSeries,
    required this.name,
    required this.names,
    required this.pokemonEntries,
    required this.region,
    required this.versionGroups,
  });

  factory ResponsePokedex.fromRawJson(String str) =>
      ResponsePokedex.fromMap(json.decode(str));

  factory ResponsePokedex.fromMap(Map<String, dynamic> json) => ResponsePokedex(
        descriptions: List<Description>.from(json["descriptions"]
            .map((x) => Description.fromMap(converterDynamicMap(x)))),
        id: json["id"],
        isMainSeries: json["is_main_series"],
        name: json["name"],
        names: List<Name>.from(
            json["names"].map((x) => Name.fromMap(converterDynamicMap(x)))),
        pokemonEntries: List<PokemonEntry>.from(json["pokemon_entries"]
            .map((x) => PokemonEntry.fromMap(converterDynamicMap(x)))),
        region: json["region"] == null
            ? null
            : Region.fromMap(converterDynamicMap(json["region"])),
        versionGroups: List<Region>.from(json["version_groups"]
            .map((x) => Region.fromMap(converterDynamicMap(x)))),
      );

  Map<String, dynamic> toMap() => {
        "descriptions": List<dynamic>.from(descriptions.map((x) => x.toMap())),
        "id": id,
        "is_main_series": isMainSeries,
        "name": name,
        "names": List<dynamic>.from(names.map((x) => x.toMap())),
        "pokemon_entries":
            List<dynamic>.from(pokemonEntries.map((x) => x.toMap())),
        "region": region?.toMap(),
        "version_groups":
            List<dynamic>.from(versionGroups.map((x) => x.toMap())),
      };

  String toJson() => json.encode(toMap());
  
  @override
  List<Object?> get props => [id, pokemonEntries];
}

class Description {
  final String description;
  final Region language;

  Description({
    required this.description,
    required this.language,
  });

  factory Description.fromMap(Map<String, dynamic> json) => Description(
        description: json["description"],
        language: Region.fromMap(converterDynamicMap(json["language"])),
      );

  Map<String, dynamic> toMap() => {
        "description": description,
        "language": language.toMap(),
      };
}

class Region extends Pokemon {
  Region({
    super.name,
    super.url,
  });

  factory Region.fromMap(Map<String, dynamic> json) => Region(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "url": url,
      };
}

class Name {
  final Region language;
  final String name;

  Name({
    required this.language,
    required this.name,
  });

  factory Name.fromMap(Map<String, dynamic> json) => Name(
        language: Region.fromMap(converterDynamicMap(json["language"])),
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "language": language.toMap(),
        "name": name,
      };
}

class PokemonEntry extends CharacterPokemonEntry {
  final Region pokemonSpeciesRegion;
  PokemonEntry({super.entryNumber, required this.pokemonSpeciesRegion})
      : super(pokemonSpecies: pokemonSpeciesRegion);

  factory PokemonEntry.fromMap(Map<String, dynamic> json) => PokemonEntry(
        entryNumber: json["entry_number"],
        pokemonSpeciesRegion:
            Region.fromMap(converterDynamicMap(json["pokemon_species"])),
      );

  Map<String, dynamic> toMap() => {
        "entry_number": entryNumber,
        "pokemon_species": pokemonSpeciesRegion.toMap(),
      };
}
