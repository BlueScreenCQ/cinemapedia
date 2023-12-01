import 'package:cinemapedia/presentation/providers/tv/tv_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/movie.dart';

final tvSlideshowProvider = Provider<List<Movie>>((ref) {
  final onAirSeries = ref.watch(airingTodayProvider);

  if (onAirSeries.isEmpty) return [];

  return onAirSeries.sublist(0, 6);
});
