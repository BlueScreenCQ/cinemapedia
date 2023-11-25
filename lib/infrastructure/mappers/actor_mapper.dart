import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_person_response.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) => Actor(
      id: cast.id,
      name: cast.name,
      profilePath: cast.profilePath != null
          ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
          : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg',
      character: cast.character);

  static Actor PersonToEntity(Person person) => Actor(
        id: person.id,
        name: person.name,
        profilePath: person.profilePath != null
            ? 'https://image.tmdb.org/t/p/w500${person.profilePath}'
            : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg',
        character: "",
        adult: person.adult,
        birthday: person.birthday,
        deatday: person.deathday,
        gender: person.gender,
        biography: person.biography,
        knownForDepartment: person.knownForDepartment,
        placeOfBirth: person.placeOfBirth,
      );
}
