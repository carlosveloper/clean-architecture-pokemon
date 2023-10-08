import 'package:cleandex/data/model/response/pokedex_response.dart' as cleandex;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PokedexResponse', () {
    late String referenceRawJson;
    late cleandex.ResponsePokedex referenceDto;

    setUp(() {
      referenceDto = cleandex.ResponsePokedex(
        descriptions: [
          cleandex.Description(
            description: "Bulbasaur can be seen napping in bright sunlight.",
            language: cleandex.Region(
                name: "en", url: "https://pokeapi.co/api/v2/language/9/"),
          ),
        ],
        id: 1,
        isMainSeries: true,
        name: "national",
        names: [
          cleandex.Name(
            language: cleandex.Region(
                name: "en", url: "https://pokeapi.co/api/v2/language/9/"),
            name: "National",
          ),
        ],
        pokemonEntries: [
          cleandex.PokemonEntry(
            entryNumber: 1,
            pokemonSpeciesRegion: cleandex.Region(
                name: "bulbasaur",
                url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
          ),
        ],
        region: null,
        versionGroups: [
          cleandex.Region(
              name: "red-blue",
              url: "https://pokeapi.co/api/v2/version-group/1/"),
        ],
      );

      referenceRawJson = referenceDto.toJson();
    });

    test('should create ResponsePokedex instance to/from JSON', () {

      final createdDto = cleandex.ResponsePokedex.fromRawJson(referenceRawJson);
      final json = createdDto.toJson();

      expect(json, referenceRawJson);
      expect(createdDto, referenceDto);
    });
  });
}
