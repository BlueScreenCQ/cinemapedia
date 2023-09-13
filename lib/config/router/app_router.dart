import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
  routes: [
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder:(context, state) {

        final pageIndex = state.pathParameters['page'] ?? '0';

        return HomeScreen(pageIndex: int.parse(pageIndex));
      },
      routes: [
        GoRoute(
          path: 'movie/:id', // quitamos el primer slash / porque es la ruta del padre
          name: MovieScreen.name,
          builder: (context, state) {

            final movieID = state.pathParameters['id']  ?? 'no-id';

            return MovieScreen(movieId: movieID);
          }
        )
      ]
      ), 

      GoRoute(
        path: '/',
        redirect: (_, __) => '/home/0',
        )
  ]
);