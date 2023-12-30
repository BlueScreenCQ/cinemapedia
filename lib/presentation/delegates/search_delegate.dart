import 'dart:async';
// import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/providers/search/search_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/choice_chip.dart';
import 'package:flutter/material.dart';
import 'package:cinemapedia/domain/entities/search_item.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

typedef SearchCallback = Future<List<SearchItem>> Function(String query);

class CustomSearchDelegate extends SearchDelegate<SearchItem?> {
  final WidgetRef ref;

  int? searchType;
  SearchCallback? searchCallback;
  List<SearchItem> initialItems = [];
  List<SearchItem> searchedItems = [];
  String searchQuery = '';
  String customSearchFieldLabel = '';

  StreamController<List<SearchItem>> debounceItems = StreamController.broadcast();
  StreamController<bool> isLoading = StreamController.broadcast();

  Timer? _debounceTimer;

  CustomSearchDelegate({required this.ref}) {
    searchType = ref.read(searchProvider.notifier).state;

    switch (searchType) {
      case 0: //Pelis
        searchedItems = ref.read(searchedMoviesProvider);
        searchQuery = ref.read(searchQueryProvider);
        searchCallback = ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery;
        customSearchFieldLabel = "Buscar películas";
        break;
      case 1: //Series
        searchedItems = ref.read(searchedTVProvider);
        searchQuery = ref.read(searchQueryProvider);
        searchCallback = ref.read(searchedTVProvider.notifier).searchMoviesByQuery;
        customSearchFieldLabel = "Buscar series y TV";
        break;
      case 2: //Actores
        searchedItems = ref.read(searchedActorsProvider);
        searchQuery = ref.read(searchQueryProvider);
        searchCallback = ref.read(searchedActorsProvider.notifier).searchActorsByQuery;
        customSearchFieldLabel = "Buscar actores y reparto";
        break;
      default: //Ponemos pelis para que no se queje el Callback pero es imposible que pase a priori
        searchedItems = ref.read(searchedMoviesProvider);
        searchQuery = ref.read(searchQueryProvider);
        searchCallback = ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery;
        customSearchFieldLabel = "Buscar películas";
        break;
    }
  }

  void clearStream() {
    debounceItems.close();
    isLoading.close();
  }

  void _onQueryChange(String query) {
    isLoading.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      // if(query.isEmpty) {
      //   debounceMovies.add([]);
      //   return;
      // }

      final items = await searchCallback!(query);

      debounceItems.add(items);
      initialItems = items;

      isLoading.add(false);
    });
  }

  @override
  String get searchFieldLabel => customSearchFieldLabel;

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initialItems,
      stream: debounceItems.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return Column(
          children: [
            const SizedBox(
              height: 50.0,
              child: CustomChoiceChip(
                items: ['Películas', 'Series y TV', 'Personas'],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) => _SearchItem(
                      item: movies[index],
                      onMovieSelected: (context, movie) {
                        clearStream();
                        close(context, movie);
                      })),
            ),
          ],
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
          stream: isLoading.stream,
          initialData: false,
          builder: (context, snapshot) {
            if (snapshot.data ?? false) {
              return SpinPerfect(
                duration: const Duration(seconds: 10),
                infinite: true,
                spins: 10,
                child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.refresh_rounded)),
              );
            }

            return FadeIn(
              animate: query.isNotEmpty,
              child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear_rounded)),
            );
          }),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStream();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Controlar el disparo de querys
    _onQueryChange(query);

    return buildResultsAndSuggestions();
  }
}

class _SearchItem extends StatelessWidget {
  final SearchItem item;
  final Function onMovieSelected;

  const _SearchItem({required this.item, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, item);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  height: 130,
                  fit: BoxFit.cover,
                  image: NetworkImage(item.sImage),
                  placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.sName, style: textStyles.titleMedium),
                  (item.sText.length >= 150) ? Text('${item.sText.substring(0, 150)}...') : Text(item.sText),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      if (item.sDate != null) ...[
                        const Icon(Icons.calendar_month_outlined),
                        const SizedBox(width: 2),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text('${item.sDate!.year}'),
                        ),
                        const SizedBox(width: 15.0),
                      ],
                      // if (item.voteCount > 0) ...[
                      //   Icon(Icons.star_half_rounded, color: Colors.yellow.shade800),
                      //   const SizedBox(width: 2),
                      //   Padding(
                      //     padding: const EdgeInsets.only(top: 3),
                      //     child: Text(
                      //       HumanFormats.number(item.voteAverage, 2),
                      //       style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade800),
                      //     ),
                      //   )
                      // ]
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
