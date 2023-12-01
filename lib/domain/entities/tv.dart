import 'package:cinemapedia/domain/entities/crew.dart';

class TV {
  final bool adult;
  final String backdropPath;
  final List<Crew> createdBy;
  // final List<int> episodeRunTime; //TODO MIRAR
  final List<String> genreIds;
  final int id;
  final bool inProduction;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final String status;
  // final bool video;
  final double voteAverage;
  final int voteCount;
  final String name;
  final DateTime? firstAirDate;
  final DateTime? lastAirDate;

  TV({
    required this.adult,
    required this.backdropPath,
    required this.createdBy,
    required this.genreIds,
    required this.id,
    required this.inProduction,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.status,
    required this.voteAverage,
    required this.voteCount,
    required this.name,
    this.firstAirDate,
    this.lastAirDate,
  });
}
