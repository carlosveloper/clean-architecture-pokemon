import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class HiveDataBase {
  final String typeBoxCharacter = 'CHARACTER_POKEMON';

  late Box boxPokemon;

  HiveDataBase._create();
  static Future<HiveDataBase> create({Directory? directoryParams}) async {
    var component = HiveDataBase._create();
    await component.initDatabase(directoryParams: directoryParams);
    return component;
  }

  initDatabase({Directory? directoryParams}) async {
   
      Directory? directory = directoryParams;
      if (!kIsWeb && directory == null) {
        directory = await getApplicationDocumentsDirectory();
        Hive.init(p.join(directory.path));
      } else {
        await Hive.initFlutter(); // Inicializa Hive para la web
      }
      await initBoxes();
  }

  initBoxes() async {
    boxPokemon = await Hive.openBox(typeBoxCharacter);
  }

  /// Get a name list of existing boxes
  FutureOr<List<String>> getNamesOfBoxes() async {
    var appDir = await getApplicationDocumentsDirectory();
    var files = appDir.listSync();
    var list = <String>[];

    for (var file in files) {
      if (file.statSync().type == FileSystemEntityType.file &&
          p.extension(file.path).toLowerCase() == '.hive') {
        list.add(p.basenameWithoutExtension(file.path));
      }
    }

    return list;
  }

  void deleteBoxes() async {
    var boxes = await getNamesOfBoxes();
    if (boxes.isNotEmpty) {
      for (var name in boxes) {
        deleteBoxFromDisk(name);
      }
    }
  }

  void clearBoxes() async {
    var boxes = await getNamesOfBoxes();
    if (boxes.isNotEmpty) {
      for (var name in boxes) {
        Hive.box(name).clear();
      }
    }
  }

  deleteBoxFromDisk(String name) {}
}
