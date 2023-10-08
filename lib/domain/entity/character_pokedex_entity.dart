// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class CharacterPokemonEntry with EquatableMixin {
  final int? entryNumber;
  final Pokemon? pokemonSpecies;
  CharacterPokemonEntry({
    this.entryNumber,
    this.pokemonSpecies,
  });
  
  @override
  List<Object?> get props => [entryNumber, pokemonSpecies];

}

class Pokemon with EquatableMixin {
  final String? name;
  final String? url;

  Pokemon({
    this.name,
    this.url,
  });

  @override
  List<Object?> get props => [
        name,
        url,
      ];
}
