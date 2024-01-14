import 'package:cinemapedia/domain/entities/movie.dart';

class MovieCollection {
  final int id;
  final String name;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  List<Movie>? parts;

  MovieCollection({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
    required this.parts,
  });
}
