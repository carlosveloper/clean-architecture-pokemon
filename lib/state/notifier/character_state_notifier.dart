import 'package:cleandex/core/network/error/app_exceptions.dart';
import 'package:cleandex/core/utils/extensions.dart';
import 'package:cleandex/state/notifier/character_page_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecase/get_all_characters.dart';

class CharacterStateNotifier extends StateNotifier<CharacterPageState> {
  CharacterStateNotifier({
    required GetAllCharacters getAllCharacters,
  })  : _getAllCharacters = getAllCharacters,
        super(const CharacterPageState());

  final GetAllCharacters _getAllCharacters;

  Future<void> fetchNextPage() async {
    try {
      if (state.hasReachedEnd) return;
      state = state.copyWith(status: CharacterPageStatus.loading);

    
      final result = await _getAllCharacters.call(page: state.currentPage + 1);

      if (result.isLeft()) {
        throw result.asLeft();
      }

      state = state.copyWith(
        status: CharacterPageStatus.success,
        currentPage:result.asRight().isNotEmpty? state.currentPage + 1:state.currentPage,
        characters: List.of(state.characters)..addAll(result.asRight()),
        hasReachedEnd: result.asRight().isEmpty,
      );
    } on AppCoreException catch (err) {
      state = state.copyWith(
          status: CharacterPageStatus.failure, message: err.message);
    } catch (e) {
      state = state.copyWith(
          status: CharacterPageStatus.failure, message: e.toString());
    }
  }
}
