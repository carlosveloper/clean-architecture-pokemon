import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleandex/core/utils/extensions.dart';
import 'package:cleandex/domain/entity/character_pokedex_entity.dart';
import 'package:flutter/material.dart';

typedef OnCharacterListItemTap = void Function(CharacterPokemonEntry character);

class CharacterListItem extends StatelessWidget {
  const CharacterListItem({
    super.key,
    required this.item,
    this.onTap,
  });

  final CharacterPokemonEntry item;
  final OnCharacterListItemTap? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(item),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.1,
        ),
        child: Card(
          elevation: 10,
          child: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            runSpacing: 5.0,
            // mainAxisSize: MainAxisSize.min,
            children: [
              _ItemPhoto(item: item),
              Text(
                item.pokemonSpecies!.name!.capitalize,
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow
                    .ellipsis, // Opcional, agrega puntos suspensivos al final del texto si se corta
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemPhoto extends StatelessWidget {
  const _ItemPhoto({Key? key, required this.item}) : super(key: key);

  final CharacterPokemonEntry item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: SizedBox(
        height: 125,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: item.pokemonSpecies != null
              ? CachedNetworkImage(
                  imageUrl:
                      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${getIdPokemon(item.pokemonSpecies?.url ?? '')}.png",
                  fit: BoxFit.cover,
                
                  errorWidget: (ctx, url, err) => const Icon(Icons.error),
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ),
                  
                 // placeholder: (ctx, url) => const Icon(Icons.image),
                )

              /* Image.network(
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${getIdPokemon(item.pokemonSpecies?.url??'')}.png",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ) */
              : const Icon(Icons.image),
        ),
      ),
    );
  }

  String getIdPokemon(String url) {
    if (url.isNotEmpty) {
      var parts = url.split('/');
      var id = parts.sublist(parts.length - 2).join('/').trim();
      id = id.replaceAll('/', '');
      return id;
    } else {
      return '0';
    }
  }
}
