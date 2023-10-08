import 'package:cleandex/domain/entity/character_pokedex_entity.dart';
import 'package:dartz/dartz.dart';

import '../../core/network/error/app_exceptions.dart';
import '../repositories/character_repository.dart';

class GetAllCharacters {
  GetAllCharacters({
    required CharacterRepository repository,
  }) : _repository = repository;

  final CharacterRepository _repository;

  Future<Either<AppCoreException, List<CharacterPokemonEntry>>> call({int page = 1}) async {
    final list = await _repository.getCharacters(page: page);
    return list;
  }
}
