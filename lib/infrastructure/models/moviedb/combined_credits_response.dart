// import 'dart:convert';

// CombinedCreditsResponse combinedCreditsResponseFromJson(String str) => CombinedCreditsResponse.fromJson(json.decode(str));

// String combinedCreditsResponseToJson(CombinedCreditsResponse data) => json.encode(data.toJson());

class CombinedCreditsResponse {
  final int id;
  final List<Cast> cast;
  final List<Cast> crew;

  CombinedCreditsResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory CombinedCreditsResponse.fromJson(Map<String, dynamic> json) => CombinedCreditsResponse(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
      };
}

class Cast {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final String character;
  final String creditId;
  // final int order;
  final String mediaType;
  // final List<String> originCountry;
  final String originalName;
  final DateTime firstAirDate;
  final String name;
  // final int episodeCount;
  final String department;
  final String job;

  Cast({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.character,
    required this.creditId,
    // required this.order,
    required this.mediaType,
    // required this.originCountry,
    required this.originalName,
    required this.firstAirDate,
    required this.name,
    // required this.episodeCount,
    required this.department,
    required this.job,
  });

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"],
        backdropPath: json["backdrop_path"] ?? '',
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"] ?? '',
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"] ?? '',
        releaseDate: (json.containsKey("release_date") && json['release_date'] != "" && DateTime.tryParse(json["release_date"]) != null) ? DateTime.parse(json["release_date"]) : DateTime(1900, 1, 1),
        title: json["title"] ?? '',
        video: json["video"] ?? false,
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
        character: json["character"] ?? '',
        creditId: json["credit_id"],
        // order: json["order"],
        mediaType: json["media_type"]!,
        // originCountry: json["origin_country"] ?? [],
        // originCountry: List<String>.from(json["originCountry"].map((x) => x)) ?? [],
        originalName: json["original_name"] ?? '',
        firstAirDate:
            (json.containsKey("first_air_date") && json['first_air_date'] != "" && DateTime.tryParse(json["first_air_date"]) != null) ? DateTime.parse(json["first_air_date"]) : DateTime(1900, 1, 1),
        name: json["name"] ?? '',
        // episodeCount: json["episode_count"],
        department: json["department"] ?? '',
        job: json["job"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "character": character,
        "credit_id": creditId,
        // "order": order,
        "media_type": mediaType,
        // "origin_country": originCountry,
        "original_name": originalName,
        "first_air_date": "${firstAirDate.year.toString().padLeft(4, '0')}-${firstAirDate.month.toString().padLeft(2, '0')}-${firstAirDate.day.toString().padLeft(2, '0')}",
        "name": name,
        // "episode_count": episodeCount,
        "department": department,
        "job": job,
      };
}
