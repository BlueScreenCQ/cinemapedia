import 'package:cinemapedia/domain/entities/search_item.dart';
import 'package:cinemapedia/domain/entities/watch_provider.dart';
import 'package:cinemapedia/domain/entities/movie_collection.dart';
import 'package:isar/isar.dart';

part 'movie.g.dart';

@collection
class Movie extends SearchItem {
  Id? isarId;

  final bool adult;
  final String backdropPath;
  final MovieCollection? belongsToCollection;
  final int? budget;
  final List<String> genreIds;
  final int id;
  final String? imdbId;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final DateTime? releaseDate;
  final int? revenue;
  final int? runtime;
  final String? status;
  final String title;
  final List<WatchProvider>? productionCompanies;
  final String? tagline;
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
      this.belongsToCollection,
      this.budget,
      required this.genreIds,
      required this.id,
      this.imdbId,
      required this.originalLanguage,
      required this.originalTitle,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      this.productionCompanies,
      this.releaseDate,
      this.revenue,
      this.runtime,
      this.status,
      this.tagline,
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
      this.job})
      : super(
            sId: id,
            sName: (name != null && name != '') ? name! : title,
            sImage: posterPath,
            sText: overview,
            sDate: releaseDate ?? firstAirDate,
            isPeli: (name != '') ? false : true,
            isTV: (name != '') ? true : false);
}
