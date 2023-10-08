import 'package:cleandex/core/network/error/app_exceptions.dart';
import 'package:cleandex/data/model/response/pokedex_response.dart';
import 'package:cleandex/domain/entity/character_pokedex_entity.dart';
import 'package:cleandex/domain/repositories/character_repository.dart';
import 'package:cleandex/domain/usecase/get_all_characters.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final characters = [
  PokemonEntry(
    entryNumber: 1,
    pokemonSpeciesRegion: Region(
        name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
  ),
  PokemonEntry(
    entryNumber: 2,
    pokemonSpeciesRegion: Region(
        name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
  ),
];

class MockCharacterRepository extends Mock implements CharacterRepository {
  @override
  Future<Either<AppCoreException, List<CharacterPokemonEntry>>> getCharacters(
      {int page = 1}) async {
    // Aquí puedes devolver una instancia de Either con datos simulados de éxito.
    return Right(characters);
  }
}

class MockCharacterRepository2 extends Mock implements CharacterRepository {
  @override
  Future<Either<AppCoreException, List<CharacterPokemonEntry>>> getCharacters(
      {int page = 1}) async {
    // Aquí puedes devolver una instancia de Either con datos simulados de éxito.
    return Left(GenericException('Mock Prueba', method: 'getCharacters'));
  }
}

void main() {
  group('CharacterApi', () {
    test(
        'getCharacters should return a list of CharacterPokemonEntry on success',
        () async {
      final mockCharacterApi = MockCharacterRepository();

      final useCase = GetAllCharacters(repository: mockCharacterApi);

      final result = await mockCharacterApi.getCharacters(page: 1);

      final resultCall = await useCase.call();

      result.fold(
        (left) => fail('test failed'),
        (right) {
          expect(right, equals(characters)); 
          expect(true, resultCall.isRight());
        },
      );

      verifyNoMoreInteractions(mockCharacterApi);
    });

    test(
        'getCharacters should return a list of CharacterPokemonEntry on failure',
        () async {
      final mockCharacterApi = MockCharacterRepository2();

      final result = await mockCharacterApi.getCharacters(page: 1);

      final useCase = GetAllCharacters(repository: mockCharacterApi);

      final resultCall = await useCase.call();

      result.fold(
        (left) {
          expect(left, isInstanceOf<GenericException>());
          expect(true, resultCall.isLeft());
        },
        (right) {
          fail('test failed: Expected Left, but got Right');
        },
      );
      verifyNoMoreInteractions(mockCharacterApi);
    });
  });
}
