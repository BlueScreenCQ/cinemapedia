import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';

final appRouter = GoRouter(initialLocation: '/home/0', routes: [
  GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = state.pathParameters['page'] ?? '0';

        return HomeScreen(pageIndex: int.parse(pageIndex));
      },
      routes: [
        GoRoute(
            path: 'movie/:id', // quitamos el primer slash / porque es la ruta del padre
            name: MovieScreen.name,
            builder: (context, state) {
              final movieID = state.pathParameters['id'] ?? 'no-id';

              return MovieScreen(movieId: movieID);
            }),
        GoRoute(
            path: 'tv/:id', // quitamos el primer slash / porque es la ruta del padre
            name: TVScreen.name,
            builder: (context, state) {
              final tvID = state.pathParameters['id'] ?? 'no-id';

              return TVScreen(tvId: tvID);
            }),
        GoRoute(
            path: 'tv/:id/:sesonN/:episodeN', // quitamos el primer slash / porque es la ruta del padre
            name: EpisodeScreen.name,
            builder: (context, state) {
              final tvID = state.pathParameters['id'] ?? 'no-id';
              final seasonNumber = state.pathParameters['sesonN'] ?? 'no-id';
              final episodeNumber = state.pathParameters['episodeN'] ?? 'no-id';

              return EpisodeScreen(tvId: tvID, seasonNumber: int.parse(seasonNumber), episodeNumber: int.parse(episodeNumber));
            }),
        GoRoute(
            path: 'actor/:id', // quitamos el primer slash / porque es la ruta del padre
            name: ActorScreen.name,
            builder: (context, state) {
              final actorID = state.pathParameters['id'] ?? 'no-id';

              return ActorScreen(actorId: actorID);
            }),
      ]),
  GoRoute(
    path: '/',
    redirect: (_, __) => '/home/0',
  )
]);
