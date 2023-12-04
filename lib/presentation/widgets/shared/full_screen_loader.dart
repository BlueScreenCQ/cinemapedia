import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  final String pageName;

  const FullScreenLoader({super.key, required this.pageName});

  Stream<String> getLoadingMessages() {
    final messagesMovies = <String>['Llegando al cine', 'Comprando palomitas', 'Las palomitas están muy caras...', 'Ya casi está...', 'Esto está tardando ;('];

    final messagesTV = <String>['Llegando al sofá', 'Haciendo palomitas', 'Buscando una serie para ver', 'Ya casi está...', 'Esto está tardando ;('];

    if (pageName == 'home') {
      return Stream.periodic(const Duration(milliseconds: 1000), (step) {
        return messagesMovies[step];
      }).take(messagesMovies.length);
    } else {
      return Stream.periodic(const Duration(milliseconds: 1000), (step) {
        return messagesTV[step];
      }).take(messagesTV.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tittleStyle = Theme.of(context).textTheme.displayLarge;
    final textStyle = Theme.of(context).textTheme.titleLarge;

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              (pageName == 'home' ? Icons.movie_outlined : Icons.live_tv_outlined),
              color: colors.primary,
              size: 50,
            ),
            const SizedBox(width: 10),
            Text('Cinemapedia', style: tittleStyle),
          ],
        ),
        const SizedBox(height: 25),
        const CircularProgressIndicator(),
        const SizedBox(height: 25),
        StreamBuilder(
          stream: getLoadingMessages(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(
                'Cargando...',
                style: textStyle,
              );
            }

            return Text(
              snapshot.data!,
              style: textStyle,
            );
          },
        )
      ]),
    );
  }
}
