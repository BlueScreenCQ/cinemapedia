import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/crew.dart';

import '../../providers/providers.dart';

class ActorsByShow extends ConsumerWidget {
  final String showId;
  final bool isTV;

  const ActorsByShow({super.key, required this.showId, this.isTV = false});

  @override
  Widget build(BuildContext context, ref) {
    final textStyle = Theme.of(context).textTheme;

    Map<String, Map<String, List>> actorsByShow;

    if (isTV) {
      actorsByShow = ref.watch(actorsBytvProvider);
    } else {
      actorsByShow = ref.watch(actorsByMovieProvider);
    }

    if (actorsByShow[showId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = actorsByShow[showId]!['Actors'];
    final crew = actorsByShow[showId]!['Crew'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (actors != null && actors.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 3, bottom: 3),
            child: Text('Reparto', style: textStyle.titleLarge),
          ),

          //Actors
          SizedBox(
            height: 280,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: actors.length,
                itemBuilder: (context, index) {
                  final Actor actor = actors[index];

                  return GestureDetector(
                    onTap: () => context.push('/home/0/actor/${actor.id}'),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 135,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        //Actor photo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            actor.profilePath,
                            height: 180,
                            width: 135,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 5),

                        //Name
                        Text(
                          actor.name,
                          maxLines: 2,
                          style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                          actor.character ?? '',
                          maxLines: 2,
                          style: const TextStyle(fontStyle: FontStyle.italic, overflow: TextOverflow.ellipsis),
                        ),
                      ]),
                    ),
                  );
                }),
          ),
        ],
        if (crew != null && crew.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 3, bottom: 3),
            child: Text('Equipo de producción', style: textStyle.titleLarge),
          ),

          //Crew
          SizedBox(
            height: 290,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: crew.length,
                itemBuilder: (context, index) {
                  final Crew item = crew[index];

                  return GestureDetector(
                    onTap: () => context.push('/home/0/actor/${item.id}'),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: 135,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        //Actor photo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            item.profilePath!,
                            height: 180,
                            width: 135,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 5),

                        //Name
                        Text(
                          item.name,
                          maxLines: 2,
                          style: const TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                        ),

                        Text(
                          item.job ?? '',
                          maxLines: 2,
                          style: const TextStyle(overflow: TextOverflow.ellipsis),
                        ),

                        if (item.department != null)
                          Text(
                            '(${item.department})',
                            maxLines: 2,
                            style: const TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                      ]),
                    ),
                  );
                }),
          ),
        ],
      ],
    );
  }
}
