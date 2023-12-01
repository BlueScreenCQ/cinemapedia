import 'package:cinemapedia/domain/entities/crew.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class CrewMapper {
  static Crew castToEntity(Cast cast) => Crew(
      id: cast.id,
      name: cast.name,
      profilePath: cast.profilePath != null
          ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
          : 'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg',
      department: cast.department,
      job: cast.job);
}
