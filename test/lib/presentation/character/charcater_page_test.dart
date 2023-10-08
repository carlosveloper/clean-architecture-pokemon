import 'package:cleandex/core/network/error/app_exceptions.dart';
import 'package:cleandex/data/model/response/pokedex_response.dart';
import 'package:cleandex/domain/entity/character_pokedex_entity.dart';
import 'package:cleandex/domain/usecase/get_all_characters.dart';
import 'package:cleandex/presentation/character/character_page.dart';
import 'package:cleandex/state/notifier/character_state_notifier.dart';
import 'package:cleandex/state/notifier/init_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

final characters = [
  PokemonEntry(
    entryNumber: 1,
    pokemonSpeciesRegion: Region(
        name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
  ),
  PokemonEntry(
    entryNumber: 2,
    pokemonSpeciesRegion: Region(
        name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon-species/2/"),
  ),
];

class GetAllCharactersMock extends Mock implements GetAllCharacters {
  @override
  Future<Either<AppCoreException, List<CharacterPokemonEntry>>> call(
      {int page = 1}) async {
    return const Right(
      [],
    );
  }
}

class GetAllCharactersMockData extends Mock implements GetAllCharacters {
  @override
  Future<Either<AppCoreException, List<CharacterPokemonEntry>>> call(
      {int page = 1}) async {
    return Right(characters);
  }
}

class TestPathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String> getTemporaryPath() async {
    // Devuelve una ruta temporal simulada para las pruebas
    return '/path/to/temporary/directory';
  }

  @override
  Future<String> getApplicationSupportPath() async {
    // Devuelve una ruta simulada para la carpeta de soporte de la aplicación
    return '/path/to/application/support/directory';
  }

  // Implementa otros métodos de PathProviderPlatform si es necesario
}

void main() {
  group('CharacterPage', () {
    late GetAllCharactersMock getAllCharactersMock;
    late GetAllCharactersMockData getAllCharactersMockData;

    setUp(() {
      getAllCharactersMock = GetAllCharactersMock();
      getAllCharactersMockData = GetAllCharactersMockData();
      TestWidgetsFlutterBinding.ensureInitialized();
      PathProviderPlatform.instance = TestPathProviderPlatform();
    });

    testWidgets('Rendering CharacterPage with no information', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            overrides: [
              characterPageStateProvider.overrideWith((ref) {
                return CharacterStateNotifier(
                    getAllCharacters: getAllCharactersMock);
              }),
            ],
            child: const CharacterPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester
          .pump(); // Asegúrate de esperar la construcción inicial del widget

      // Ahora, dentro de un contexto asincrónico, puedes simular el tiempo de carga
      await tester.runAsync(() async {
        // Espera otro segundo (simulando el tiempo de carga)
        await Future.delayed(const Duration(seconds: 2));

        // Después de simular el tiempo de carga, vuelve a construir el widget
        await tester.pump();

        // Ahora debería buscar el widget que esperas después de la carga
        expect(find.text("No data found"), findsOneWidget);
      });

      // Verifica que al principio el estado tenga el status de loading
    });

    testWidgets('Rendering CharacterPage with information', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            overrides: [
              characterPageStateProvider.overrideWith((ref) {
                return CharacterStateNotifier(
                    getAllCharacters: getAllCharactersMockData);
              }),
            ],
            child: const CharacterPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      await tester.runAsync(() async {
        await Future.delayed(const Duration(seconds: 2));
        expect(find.text("2"), findsOneWidget);
        expect(find.text("Bulbasaur"), findsOneWidget);
        expect(find.text("Ivysaur"), findsOneWidget);
      });
    });
  });
}
