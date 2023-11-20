import 'package:cinemapedia/domain/entities/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final FutureProviderFamily<List<Video>, int> videosFromMovieProvider = FutureProvider.family((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getYoutubeVideosById(movieId);
});

class VideosFromMovie extends ConsumerWidget {
  final int movieId;

  const VideosFromMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesFromVideo = ref.watch(videosFromMovieProvider(movieId));

    return moviesFromVideo.when(
      data: (videos) => _VideosList(videos: videos),
      error: (_, __) => const Center(child: Text('No se pudo cargar videos')),
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _VideosList extends StatefulWidget {
  final List<Video> videos;

  const _VideosList({required this.videos});

  @override
  State<_VideosList> createState() => _VideosListState();
}

class _VideosListState extends State<_VideosList> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {});
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textStyle = Theme.of(context).textTheme;

    //* Nada que mostrar
    if (widget.videos.isEmpty) {
      return const SizedBox();
    }

    return SizedBox(
      height: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 20, bottom: 3),
          //   child: Text('Videos', style: textStyle.titleLarge),
          // ),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                itemCount: widget.videos.length,
                scrollDirection: Axis.horizontal,
                // physics: const BouncingScrollPhysics(),
                itemBuilder: (context, item) {
                  return _YouTubeVideoPlayer(
                      youtubeId: widget.videos[item].youtubeKey, name: (widget.videos[item].name.length < 55) ? widget.videos[item].name : '${widget.videos[item].name.substring(0, 54)}...');
                }),
          ),
        ],
      ),
    );

    //Estilo anterior
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     ignore: prefer_const_constructors
    //     Padding(
    //       padding: const EdgeInsets.only(left: 10, bottom: 3),
    //       child: Text('Videos', style: textStyle.titleLarge),
    //     ),

    //     //* Aunque tengo varios videos, sólo quiero mostrar el primero
    //     _YouTubeVideoPlayer(youtubeId: widget.videos.first.youtubeKey, name: widget.videos.first.name )

    //     //* Si se desean mostrar todos los videos
    // ...videos.map(
    //   (video) => _YouTubeVideoPlayer(youtubeId: video.youtubeKey, name: video.name)
    // ).toList()
    //   ],

    // );
  }
}

class _YouTubeVideoPlayer extends StatefulWidget {
  final String youtubeId;
  final String name;

  const _YouTubeVideoPlayer({required this.youtubeId, required this.name});

  @override
  State<_YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<_YouTubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.name),
            YoutubePlayer(
              controller: _controller,
              width: size.width * 0.9,
            )
          ],
        ));
  }
}
