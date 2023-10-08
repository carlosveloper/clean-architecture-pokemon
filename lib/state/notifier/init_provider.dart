import 'package:cleandex/data/repositories/character_repository_impl.dart';
import 'package:cleandex/data/source/local/implement/character_local_source_impl.dart';
import 'package:cleandex/data/source/local/local_data_interface_source.dart';
import 'package:cleandex/data/source/network/implement/character_network_source_impl.dart';
import 'package:cleandex/data/source/network/path_remote.dart';
import 'package:cleandex/data/source/network/remote_data_source.dart';
import 'package:cleandex/domain/usecase/get_all_characters.dart';
import 'package:cleandex/state/notifier/character_page_state.dart';
import 'package:cleandex/state/notifier/character_state_notifier.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/network_info.dart';
import '../../core/network/network_service.dart';
import '../../domain/repositories/character_repository.dart';
import '../../main.dart';


var networkInfoProvider = Provider<NetworkInfo>(
  (ref) => NetworkInfoImpl(connectionChecker: Connectivity()),
);
var networkDataSource = Provider<CharacterRemoteDataSource>((ref) => CharacterRemoteDataSourceImpl(client:NetworkService(url: PathRemote.urlService) ));
var localStorageProvider = Provider<CharacterLocalDataSource>(
  (ref) => CharacterLocalDataSourceImpl(box:dataBase.boxPokemon , tipeBox: dataBase.typeBoxCharacter),
);

//DATA IMPLEMENT
var characterRepositoryProvider = Provider<CharacterRepository>(
  (ref) => CharacterRepositoryImpl(
    networkDataSource:  ref.read(networkDataSource),
    localStorage: ref.read(localStorageProvider), networkInfo:  ref.read(networkInfoProvider),
  ),
);

///USE CASE
var getAllCharactersProvider = Provider(
  (ref) => GetAllCharacters(
    repository: ref.read(characterRepositoryProvider),
  ),
);



///STATE NOTIFIER
var characterPageStateProvider =
    StateNotifierProvider<CharacterStateNotifier, CharacterPageState>(
  (ref) => CharacterStateNotifier(
    getAllCharacters: ref.read(getAllCharactersProvider),
  ),
);
