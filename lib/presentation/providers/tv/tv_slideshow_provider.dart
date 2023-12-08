import 'package:cinemapedia/presentation/providers/tv/tv_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/movie.dart';

final tvSlideshowProvider = Provider<List<Movie>>((ref) {
  final trendingSeries = ref.watch(tredingTVProvider);

  if (trendingSeries.isEmpty) return [];

  return trendingSeries.sublist(0, 6);
});
