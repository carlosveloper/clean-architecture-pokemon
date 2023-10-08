import 'package:cleandex/data/source/local/implement/character_local_source_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive/hive.dart';
import 'package:test/test.dart';
import 'package:cleandex/data/model/response/pokedex_response.dart' as cleandex;

class MockBox extends Mock implements Box {}

void main() {
  late CharacterLocalDataSourceImpl localStorage;
  late MockBox mockBox;
  late cleandex.ResponsePokedex referenceDto;

  setUp(() async {
    mockBox = MockBox();
    localStorage = CharacterLocalDataSourceImpl(
        box: mockBox, tipeBox: 'CHARACTER_POKEMON_TEST');

    referenceDto = cleandex.ResponsePokedex(
      descriptions: [],
      id: 1,
      isMainSeries: true,
      name: "national",
      names: [],
      pokemonEntries: [],
      region: null,
      versionGroups: [
        cleandex.Region(
            name: "red-blue",
            url: "https://pokeapi.co/api/v2/version-group/1/"),
      ],
    );
  });

  group('CharacterLocalDataSourceImpl', () {
    test('should save a list of ResponsePokedex per page', () async {
      // Simula que el método put no devuelve nada
      when(() => mockBox.put('CHARACTER_POKEMON_TEST_1', referenceDto.toMap()))
          .thenAnswer((_) async {});

      // Configura el mock para el segundo llamado
      when(() => mockBox.put("CHARACTER_POKEMON_TEST_2", referenceDto.toMap()))
          .thenAnswer((_) async {});

      // Realiza alguna operación que llama a mockBox.put

      // Verifica que el método put fue llamado
      // List 1
      await localStorage.saveCharactersPage(referenceDto.toMap(), 1);

      verify(() =>
              mockBox.put("CHARACTER_POKEMON_TEST_1", referenceDto.toMap()))
          .called(1);

      await localStorage.saveCharactersPage(referenceDto.toMap(), 2);

      verify(() =>
              mockBox.put("CHARACTER_POKEMON_TEST_2", referenceDto.toMap()))
          .called(1);

      verifyNoMoreInteractions(mockBox);
    });

    test('should load a list of ResponsePokedex per page', () async {
      // List 1
      when(() => mockBox.get('CHARACTER_POKEMON_TEST_1', defaultValue: {}))
          .thenAnswer((invocation) => referenceDto.toMap());

      final result1 = await localStorage.loadCharactersPage(1);

      expect(result1, referenceDto.toMap());

      verify(() => mockBox.get('CHARACTER_POKEMON_TEST_1', defaultValue: {}))
          .called(1);
      verifyNoMoreInteractions(mockBox);
    });
  });
}
