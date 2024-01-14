import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie_collection.dart';
import 'package:cinemapedia/presentation/providers/collections/collection_info_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_horizontal_listview.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_gradient.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_read_more_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  static const name = 'collection-screen';

  final String collectionId;

  const CollectionScreen({super.key, required this.collectionId});

  @override
  CollectionScreenState createState() => CollectionScreenState();
}

class CollectionScreenState extends ConsumerState<CollectionScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(collectionInfoProvider.notifier).loadMovieCollection(widget.collectionId);
  }

  @override
  Widget build(BuildContext context) {
    //El Map está en el provider y va a mantener los datos de las pelis que ya se han consultado
    final MovieCollection? collection = ref.watch(collectionInfoProvider)[widget.collectionId];

    if (collection == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        // body: Center(child: Text(widget.collectionId))
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [_CustomSliverAppbar(collection: collection), SliverList(delegate: SliverChildBuilderDelegate((context, index) => _CollectionDetails(collection: collection), childCount: 1))],
      ),
    );
  }
}

class _CustomSliverAppbar extends ConsumerWidget {
  final MovieCollection collection;

  const _CustomSliverAppbar({required this.collection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.25,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 0),
        //Gradiente título
        title: const CustomGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [
          0.8,
          1.0
        ], colors: [
          Colors.transparent,
          Colors.black54,
        ]),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                collection.backdropPath!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),

            //Gradiente botón fav
            const CustomGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, stops: [
              0.0,
              0.2
            ], colors: [
              Colors.black54,
              Colors.transparent,
            ]),

            //Gradiente flecha atrás
            const CustomGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [
              0.0,
              0.3
            ], colors: [
              Colors.black54,
              Colors.transparent,
            ]),
          ],
        ),
      ),
    );
  }
}

class _CollectionDetails extends StatelessWidget {
  final MovieCollection collection;

  const _CollectionDetails({required this.collection});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    collection.posterPath!,
                    width: size.width * 0.3,
                  ),
                ),

                const SizedBox(height: 10.0),

                // Número de pelis
                if (collection.parts != null && collection.parts!.isNotEmpty)
                  SizedBox(
                      width: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.video_collection_outlined,
                            size: 22,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${collection.parts!.length} partes',
                            style: textStyle.titleMedium,
                          ),
                        ],
                      )),
              ],
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: (size.width * 0.7) - 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(collection.name, style: textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3.0),
                  // Text(movie.overview),
                  CustomReadMoreText(
                    text: collection.overview!,
                    trimLines: 8,
                    textStyle: textStyle.bodyLarge,
                  ),
                ],
              ),
            ),
          ]),
        ),

        //* Películas de la colección
        if (collection.parts != null && collection.parts!.isNotEmpty)
          MovieHorizontalListview(
            movies: collection.parts!,
            showDate: true,
            onlyYear: true,
            title: 'Contenido de esta colección',
          )

        // const SizedBox(height: 50)
      ],
    );
  }
}
