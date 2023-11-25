import 'package:isar/isar.dart';

part 'movie.g.dart';

@collection
class Movie {
  Id? isarId;

  final bool adult;
  final String backdropPath;
  final List<String> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime? releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final String? name;

  //PARA CAST
  final String? mediaType;
  final DateTime? firstAirDate;
  final int? episodeCount;
  final String? character;
  final String? department;
  final String? job;

  Movie(
      {required this.adult,
      required this.backdropPath,
      required this.genreIds,
      required this.id,
      required this.originalLanguage,
      required this.originalTitle,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      this.releaseDate,
      required this.title,
      required this.video,
      required this.voteAverage,
      required this.voteCount,
      this.name,
      this.mediaType,
      this.character,
      this.firstAirDate,
      this.episodeCount,
      this.department,
      this.job});
}
