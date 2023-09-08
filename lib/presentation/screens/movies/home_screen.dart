import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeView(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingProvider.notifier).loadNextPage();
    ref.read(popularProvider.notifier).loadNextPage();
    ref.read(topRatedProvider.notifier).loadNextPage();
    ref.read(upcomingProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);

    if(initialLoading) return const FullScreenLoader();

    //CARGA INICIAL//

    final slideshowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingProvider);
    final popularMovies = ref.watch(popularProvider);
    final upcomingMovies = ref.watch(upcomingProvider);
    final topRatedMovies = ref.watch(topRatedProvider);

    
    return CustomScrollView(
      slivers: [
        
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppBar(),
            titlePadding: EdgeInsets.zero,
          ),
          
        ),

        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            children: [

              // const CustomAppBar(),

              MoviesSlideshow(movies: slideshowMovies),

              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: 'En cines',
                subTitle: 'Lunes 20',
                showDate: true,
                loadNextPage: () => ref.read(nowPlayingProvider.notifier).loadNextPage(),
              ),
              MovieHorizontalListview(
                movies: upcomingMovies,
                title: 'Próximamente',
                subTitle: 'Este mes',
                showDate: true,
                loadNextPage: () => ref.read(upcomingProvider.notifier).loadNextPage(),
              ),
              MovieHorizontalListview(
                movies: popularMovies,
                title: 'Populares',
                // subTitle: '',
                loadNextPage: () => ref.read(popularProvider.notifier).loadNextPage(),
              ),
              MovieHorizontalListview(
                movies: topRatedMovies,
                title: 'Mejor valoradas',
                subTitle: 'Desde siempre',
                loadNextPage: () => ref.read(topRatedProvider.notifier).loadNextPage(),
              ),
              const SizedBox(height: 20)
            ],
          );
        }, 
        childCount: 1))
    ]);
  }
}
