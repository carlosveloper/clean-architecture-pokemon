import 'package:cleandex/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/notifier/character_page_state.dart';
import '../../state/notifier/character_state_notifier.dart';
import '../../state/notifier/init_provider.dart';
import 'widget/character_list_item.dart';

class CharacterPage extends ConsumerStatefulWidget {
  const CharacterPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CharacterPageState();
}

class _CharacterPageState extends ConsumerState<CharacterPage> {
  final _scrollController = ScrollController();
  late CharacterStateNotifier stateNotifier;
  late CharacterPageState state;
  int lastVisibleIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(characterPageStateProvider.notifier).fetchNextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    stateNotifier = ref.watch(characterPageStateProvider.notifier);
    state = ref.watch(characterPageStateProvider);

    var widgetData = state.status == CharacterPageStatus.initial
        ? const Center(child: CircularProgressIndicator())
        : state.status == CharacterPageStatus.failure &&
                state.characters.isEmpty
            ? Center(
                child: Text(
                  state.message,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              )
            : state.status == CharacterPageStatus.success &&
                    state.characters.isEmpty
                ? Center(
                    child: Text(
                      "No data found",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  )
                : Column(
                    children: [
                      Text(state.characters.length.toString()),
                      Expanded(child: body()),
                    ],
                  );
    return Scaffold(body: widgetData);
  }

  Widget body() {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: NotificationListener(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            if (scrollNotification.metrics.atEdge &&
                scrollNotification.metrics.pixels != 0.0) {

              // El desplazamiento ha terminado, puedes realizar acciones aquí si es necesario.
              if (state.status != CharacterPageStatus.loading) {

                stateNotifier.fetchNextPage();
              }
            }
          }
          return false;
        },
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size.width <= 300
                ? 1
                : size.width > 1100
                    ? 4
                    : size.width > 950
                        ? 3
                        : 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.2),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          key: const ValueKey('character_page_list_key'),
          controller: _scrollController,
          itemCount: state.hasReachedEnd
              ? state.characters.length
              : state.characters.length + 1,
          itemBuilder: (context, index) {
            if (index >= state.characters.length &&
                state.status == CharacterPageStatus.loading) {
              return !state.hasReachedEnd
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox();
            }

            if (index >= 0 && index < state.characters.length) {
              final item = state.characters[index];


            //  return Text(index.toString());

              return CharacterListItem(
                item: item,
                onTap: (character) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(character.pokemonSpecies!.name!.capitalize),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

 

}
