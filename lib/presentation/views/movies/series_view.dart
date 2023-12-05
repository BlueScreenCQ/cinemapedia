import 'package:cinemapedia/presentation/providers/tv/tv_initial_loading_provider.dart';
import 'package:cinemapedia/presentation/providers/tv/tv_provider.dart';
import 'package:cinemapedia/presentation/providers/tv/tv_slideshow_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/widgets.dart';

class SeriesView extends ConsumerStatefulWidget {
  const SeriesView({super.key});

  @override
  SeriesViewState createState() => SeriesViewState();
}

class SeriesViewState extends ConsumerState<SeriesView> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    ref.read(airingTodayProvider.notifier).loadNextPage();
    ref.read(tredingTVProvider.notifier).loadNextPage();
    ref.read(popularProvider.notifier).loadNextPage();
    ref.read(topRatedtvProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final initialLoading = ref.watch(tvLoadingProvider);

    if (initialLoading) return const FullScreenLoader(pageName: 'tv');

    //CARGA INICIAL//

    final slideshowSeries = ref.watch(tvSlideshowProvider);
    final airingTodayTV = ref.watch(airingTodayProvider);
    final trendingTV = ref.watch(tredingTVProvider);
    final popularTV = ref.watch(popularProvider);
    final topRatedTV = ref.watch(topRatedtvProvider);

    return CustomScrollView(slivers: [
      const SliverAppBar(
        floating: true,
        flexibleSpace: FlexibleSpaceBar(
          title: CustomAppBar('tv'),
          titlePadding: EdgeInsets.zero,
        ),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Column(
          children: [
            // const CustomAppBar(),

            MoviesSlideshow(movies: slideshowSeries),

            MovieHorizontalListview(
              movies: airingTodayTV,
              title: 'Se emite hoy',
              // subTitle: 'Lunes 20',
              showDate: true,
              loadNextPage: () => ref.read(airingTodayProvider.notifier).loadNextPage(),
            ),
            MovieHorizontalListview(
              movies: trendingTV,
              title: 'En tendencia',
              // subTitle: 'Desde hoy',
              showDate: true,
              loadNextPage: () => ref.read(tredingTVProvider.notifier).loadNextPage(),
            ),
            MovieHorizontalListview(
              movies: popularTV,
              title: 'Populares',
              showDate: true,
              onlyYear: false,
              // subTitle: '',
              loadNextPage: () => ref.read(popularProvider.notifier).loadNextPage(),
            ),
            MovieHorizontalListview(
              movies: topRatedTV,
              title: 'Mejor valoradas',
              // subTitle: 'Desde siempre',
              showDate: true,
              onlyYear: true,
              loadNextPage: () => ref.read(topRatedtvProvider.notifier).loadNextPage(),
            ),
            const SizedBox(height: 20)
          ],
        );
      }, childCount: 1))
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
