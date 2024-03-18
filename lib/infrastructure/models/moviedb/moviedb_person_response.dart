// To parse this JSON data, do
//
//     final person = personFromJson(jsonString);

import 'dart:convert';

Person personFromJson(String str) => Person.fromJson(json.decode(str));

String personToJson(Person data) => json.encode(data.toJson());

class Person {
  final bool adult;
  final List<String> alsoKnownAs;
  final String biography;
  final DateTime? birthday;
  final DateTime? deathday;
  final int gender;
  final dynamic homepage;
  final int id;
  final String? imdbId;
  final String knownForDepartment;
  final String name;
  final String? placeOfBirth;
  final double popularity;
  final String profilePath;

  Person({
    required this.adult,
    required this.alsoKnownAs,
    required this.biography,
    required this.birthday,
    required this.deathday,
    required this.gender,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.knownForDepartment,
    required this.name,
    required this.placeOfBirth,
    required this.popularity,
    required this.profilePath,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        adult: json["adult"],
        alsoKnownAs: List<String>.from(json["also_known_as"].map((x) => x)),
        biography: json["biography"],
        birthday: json["birthday"] != null ? DateTime.parse(json["birthday"]) : null,
        deathday: json["deathday"] != null ? DateTime.parse(json["deathday"]) : null,
        gender: json["gender"],
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"] != null ? json['imdb_id'] : null,
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        placeOfBirth: json["place_of_birth"],
        popularity: json["popularity"]?.toDouble(),
        profilePath: json["profile_path"],
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "also_known_as": List<dynamic>.from(alsoKnownAs.map((x) => x)),
        "biography": biography,
        "birthday": "${birthday?.year.toString().padLeft(4, '0')}-${birthday?.month.toString().padLeft(2, '0')}-${birthday?.day.toString().padLeft(2, '0')}",
        "deathday": "${deathday?.year.toString().padLeft(4, '0')}-${deathday?.month.toString().padLeft(2, '0')}-${deathday?.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "known_for_department": knownForDepartment,
        "name": name,
        "place_of_birth": placeOfBirth,
        "popularity": popularity,
        "profile_path": profilePath,
      };
}

/*
Value	Gender
0	Not set / not specified
1	Female
2	Male
3	Non-binary
*/
