import 'package:cleandex/data/source/local/local_data_interface_source.dart';
import 'package:hive/hive.dart';

class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  final Box box;
  final String tipeBox;

  CharacterLocalDataSourceImpl({
    required this.box,
    required this.tipeBox,
  });

  @override
  Future<Map<String, dynamic>> loadCharactersPage(int page) {
    var data = box.get('${tipeBox}_$page', defaultValue: {});

    Map<String, dynamic> mapaConvertido = {};

    data.forEach((key, value) {
      mapaConvertido[key.toString()] = value;
    });

    return Future.value(mapaConvertido);
  }

  @override
  Future<void> saveCharactersPage(Map<String, dynamic> data, int page) async {
    await box.put('${tipeBox}_$page', data);
  }
}
