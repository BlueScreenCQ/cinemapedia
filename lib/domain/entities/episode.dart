import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/crew.dart';

class Episode {
  final int id;
  final String name;
  final String overview;
  final DateTime? airDate;
  final int episodeNumber;
  final String episodeType;
  final String productionCode;
  final int runtime;
  final int seasonNumber;
  final int showId;
  final String stillPath;
  final int voteCount;
  final double voteAverage;

  final List<Actor> guestStars;
  final List<Crew> crew;

  Episode(
      {required this.id,
      required this.name,
      required this.overview,
      required this.voteAverage,
      required this.voteCount,
      required this.airDate,
      required this.episodeNumber,
      required this.episodeType,
      required this.productionCode,
      required this.runtime,
      required this.seasonNumber,
      required this.showId,
      required this.stillPath,
      required this.guestStars,
      required this.crew});
}
