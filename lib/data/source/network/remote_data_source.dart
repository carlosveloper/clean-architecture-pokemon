import '../../model/response/pokedex_response.dart';


abstract class CharacterRemoteDataSource {
  Future<ResponsePokedex> getAllCharacter(int page);
}

