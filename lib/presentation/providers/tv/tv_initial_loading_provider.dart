import 'package:cinemapedia/presentation/providers/tv/tv_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tvLoadingProvider = Provider<bool>((ref) {
  final step1 = ref.watch(airingTodayProvider).isEmpty;
  final step2 = ref.watch(onTheAirProvider).isEmpty;
  final step3 = ref.watch(popularProvider).isEmpty;
  final step4 = ref.watch(topRatedtvProvider).isEmpty;

  if (step1 || step2 || step3 || step4) return true;

  return false;
});
