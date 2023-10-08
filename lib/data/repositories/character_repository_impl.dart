import 'package:cleandex/core/network/error/app_exceptions.dart';

import 'package:cleandex/domain/entity/character_pokedex_entity.dart';

import 'package:dartz/dartz.dart';

import '../../core/network/error/app_excute_exception.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/character_repository.dart';
import '../model/response/pokedex_response.dart';
import '../source/local/local_data_interface_source.dart';
import '../source/network/remote_data_source.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource _networkDataSource;
  final CharacterLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  CharacterRepositoryImpl({
    required CharacterRemoteDataSource networkDataSource,
    required CharacterLocalDataSource localStorage,
    required NetworkInfo networkInfo,
  })  : _networkDataSource = networkDataSource,
        _localDataSource = localStorage,
        _networkInfo = networkInfo;

  @override
  Future<Either<AppCoreException, List<CharacterPokemonEntry>>> getCharacters(
      {int page = 1}) async {
    var excuteData = AppExcute<List<CharacterPokemonEntry>>();

    if (await _networkInfo.isConnected) {
      return excuteData.repositoryExcute(
          onCall: () async {
            var response = await _networkDataSource.getAllCharacter(page);
            await _localDataSource.saveCharactersPage(response.toMap(), page);
            return response.pokemonEntries;
          },
          nameMethod: 'NetworkgetCharacters');
    } else {
      return excuteData.repositoryExcute(
          onCall: () async {
            var data = await _localDataSource.loadCharactersPage(page);
            if (data.isEmpty) {
              return [];
            }
            var response = ResponsePokedex.fromMap(data);
            return response.pokemonEntries;
          },
          nameMethod: 'localGetCharacters');
    }
  }
}
