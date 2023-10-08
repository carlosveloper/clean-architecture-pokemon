import 'package:cleandex/domain/entity/character_pokedex_entity.dart';
import 'package:test/test.dart';

void main() {
  group('CharacterPokemonEntry', () {
    test('equatable props', () {
      final entry1 = CharacterPokemonEntry(
        entryNumber: 1,
        pokemonSpecies: Pokemon(name: 'Pikachu', url: 'https://example.com/pikachu'),
      );

      final entry2 = CharacterPokemonEntry(
        entryNumber: 1,
        pokemonSpecies: Pokemon(name: 'Pikachu', url: 'https://example.com/pikachu'),
      );

      final entry3 = CharacterPokemonEntry(
        entryNumber: 2,
        pokemonSpecies: Pokemon(name: 'Charmander', url: 'https://example.com/charmander'),
      );

      expect(entry1, equals(entry2)); // Deben ser iguales porque tienen las mismas propiedades
      expect(entry1, isNot(equals(entry3))); // Deben ser diferentes porque tienen entryNumber diferente
    });
  });

  group('Pokemon', () {
    test('equatable props', () {
      final pokemon1 = Pokemon(name: 'Pikachu', url: 'https://example.com/pikachu');
      final pokemon2 = Pokemon(name: 'Pikachu', url: 'https://example.com/pikachu');
      final pokemon3 = Pokemon(name: 'Charmander', url: 'https://example.com/charmander');

      expect(pokemon1, equals(pokemon2)); // Deben ser iguales porque tienen las mismas propiedades
      expect(pokemon1, isNot(equals(pokemon3))); // Deben ser diferentes porque tienen nombres diferentes
    });
  });
}