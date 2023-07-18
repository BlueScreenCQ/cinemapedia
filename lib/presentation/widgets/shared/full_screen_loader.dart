import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});


  Stream<String> getLoadingMessages() {

      final messages = <String> [
        'Llegando al cine',
        'Haciendo palomitas',
        'Buscando buenas pelis',
        'Ya casi está...',
        'Esto está tardando ;('
      ];

    return Stream.periodic(const Duration(milliseconds: 1500), (step) {
      return messages[step];
    }).take(messages.length);
  }


  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final tittleStyle = Theme.of(context).textTheme.displayLarge;
    final textStyle = Theme.of(context).textTheme.titleLarge;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie_outlined, color: colors.primary, size: 50,),
              const SizedBox(width: 10),
              Text('Cinemapedia', style: tittleStyle),
            ],
          ),
          
          
          const SizedBox(height: 25),
          
          const CircularProgressIndicator(),

          const SizedBox(height: 25),

          StreamBuilder(
            stream: getLoadingMessages(),
            builder:(context, snapshot) {
              if (!snapshot.hasData) return Text('Cargando películas...', style: textStyle,);

              return Text(snapshot.data!, style: textStyle,);
            }, 
          
          )

        ]),
    );
  }
}