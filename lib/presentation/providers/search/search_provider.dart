import 'package:flutter_riverpod/flutter_riverpod.dart';

// Enum para representar las opciones de películas, TV y actores
// enum TipoBusqueda {
//   peliculas, 0
//   tv, 1
//   actores, 2
// }

// typedef SearchCallback = Future<List<SearchItem>> Function(String query);

int searchType = 0;

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchProvider = StateProvider<int>((ref) {
  return searchType;
});
