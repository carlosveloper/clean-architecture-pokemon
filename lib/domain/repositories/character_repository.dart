import 'package:cleandex/core/network/error/app_exceptions.dart';
import 'package:dartz/dartz.dart';

import '../entity/character_pokedex_entity.dart';

abstract class CharacterRepository {
    Future<Either<AppCoreException, List<CharacterPokemonEntry>>> getCharacters({int page = 1});
}
