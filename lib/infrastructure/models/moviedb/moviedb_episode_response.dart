import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class EpisodeResponse {
  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final DateTime? airDate;
  final int episodeNumber;
  final String episodeType;
  final String productionCode;
  final int runtime;
  final int seasonNumber;
  final int showId;
  final String stillPath;

  final List<Cast> guestStars;
  final List<Cast> crew;

  EpisodeResponse({
    required this.id,
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
    required this.crew,
    required this.guestStars,
  });

  factory EpisodeResponse.fromJson(Map<String, dynamic> json) => EpisodeResponse(
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
        airDate: json["air_date"] != null ? DateTime.parse(json["air_date"]) : null,
        episodeNumber: json["episode_number"],
        episodeType: json["episode_type"],
        productionCode: json["production_code"],
        runtime: (json["runtime"] != null) ? json["runtime"] : 0,
        seasonNumber: json["season_number"],
        showId: json["show_id"],
        stillPath: (json["still_path"] != null) ? json["still_path"] : "",
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
        guestStars: List<Cast>.from(json["guest_stars"].map((x) => Cast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "overview": overview,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        // "air_date": "${airDate.year.toString().padLeft(4, '0')}-${airDate.month.toString().padLeft(2, '0')}-${airDate.day.toString().padLeft(2, '0')}",
        "episode_number": episodeNumber,
        "episode_type": episodeType,
        "production_code": productionCode,
        "runtime": runtime,
        "season_number": seasonNumber,
        "show_id": showId,
        "still_path": stillPath,
      };
}
