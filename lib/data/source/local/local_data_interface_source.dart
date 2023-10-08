

abstract class CharacterLocalDataSource {
  Future<void> saveCharactersPage(Map<String, dynamic> data,int page);
  Future<Map<String, dynamic>> loadCharactersPage(int page);
}
