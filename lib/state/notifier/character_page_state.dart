import 'package:equatable/equatable.dart';
import '../../domain/entity/character_pokedex_entity.dart';

enum CharacterPageStatus { initial, loading, success, failure }

class CharacterPageState extends Equatable {
  const CharacterPageState({
    this.status = CharacterPageStatus.initial,
    this.characters = const [],
    this.hasReachedEnd = false,
    this.currentPage = 1,
    this.message = '',
  });

  final CharacterPageStatus status;
  final List<CharacterPokemonEntry> characters;
  final bool hasReachedEnd;
  final int currentPage;
  final String message;

  CharacterPageState copyWith({
    CharacterPageStatus? status,
    List<CharacterPokemonEntry>? characters,
    String? message,
    bool? hasReachedEnd,
    int? currentPage,
  }) {
    return CharacterPageState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        status,
        characters,
        hasReachedEnd,
        currentPage,
      ];
}
