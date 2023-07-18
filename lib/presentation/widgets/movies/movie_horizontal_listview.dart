import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';


class MovieHorizontalListview extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.title, 
    this.subTitle,
    this.loadNextPage
  });

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {


  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    scrollController.addListener(() {
      if ( widget.loadNextPage == null ) return;

      if ( (scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent ) {
        widget.loadNextPage!();
      }

    });

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [

          if ( widget.title != null || widget.subTitle != null )
            _Title(title: widget.title, subTitle: widget.subTitle ),

          const SizedBox(height: 5.0),


          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeInRight(
                  child: FadeInRight(
                    child: _Slide(movie: widget.movies[index])
                    )
                  );
              },
            )
          )

        ],
      ),
    );
  }
}


class _Slide extends StatelessWidget {

  final Movie movie;

  const _Slide({ required this.movie });

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          //* Imagen
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if ( loadingProgress != null ) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator(strokeWidth: 2 )),
                    );
                  }
                  return FadeIn(child: child);
                },
              ),
            ),
          ),

          const SizedBox(height: 5),

          //* Title
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 1,
              style: textStyles.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          //* Rating
          SizedBox(
            width: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon( Icons.star_half_outlined, color: Colors.yellow.shade800 ),
                const SizedBox(width: 2),
                Text('${ movie.voteAverage }', style: textStyles.bodyMedium?.copyWith( color: Colors.yellow.shade800 )),
                const Spacer(),
                // const SizedBox(width: 15.0),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text( HumanFormats.number(movie.popularity), style: textStyles.bodySmall ),
                ),
                const Text( ' votos' ),
                    
              ],
            ),
          )


        ],
      ),
    );
  }
}



class _Title extends StatelessWidget {

  final String? title;
  final String? subTitle;


  const _Title({ this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {

    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only( top: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          
          if ( title != null )
            Text(title!, style: titleStyle ),
          
          const Spacer(),

          if ( subTitle != null )
            FilledButton.tonal(
              style: const ButtonStyle( visualDensity: VisualDensity.compact ),
              onPressed: (){}, 
              child: Text( subTitle! )
          )

        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// import '../../../domain/entities/movie.dart';

// class MovieHorizontalListview extends StatelessWidget {

//   final List<Movie> movies;
//   final String? tittle;
//   final String? subtittle;
//   final VoidCallback? loadNextPage;
  

//   const MovieHorizontalListview({
//     super.key, 
//     required this.movies, 
//     this.tittle, 
//     this.subtittle,
//     this.loadNextPage
//     });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 350,
//       child: Column(
//         children: [
//           Row(
//             children: [

//               if(tittle != null || subtittle != null)
//               _Tittle(
//                 tittle: tittle,
//                 subtitle: subtittle,
//                 ),

//               // Expanded(
//               //   // child: ListView.builder(
//               //   //   itemCount: movies.length,
//               //   //   scrollDirection: Axis.horizontal,
//               //   //   physics: const  BouncingScrollPhysics(),
//               //   //   itemBuilder: (context, index) {
//               //   //     return _Slide(movie: movies[index]);
//               //   //   }
//               //     )),    
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }


// class _Tittle extends StatelessWidget {

//   final String? tittle;
//   final String? subtitle;

//   const _Tittle({this.tittle, this.subtitle});

//   @override
//   Widget build(BuildContext context) {

//     final tittleStyle = Theme.of(context).textTheme.titleLarge;

//     return Container(
//       padding: const EdgeInsets.only(top: 10),
//       margin: const EdgeInsets.symmetric(horizontal: 10),
//       child: Row(
//         children: [

//           if(tittle != null)
//             Text(tittle!, style: tittleStyle),
            
//           const SizedBox(width: 230), //TODO ARREGLAR

//           if(subtitle != null)
//             FilledButton.tonal(
//               style: const ButtonStyle(visualDensity: VisualDensity.compact),
//               onPressed: () {}, 
//               child: Text(subtitle!),
//               ),
//         ]
//         ),
//     );
//   }
// }

// class _Slide extends StatelessWidget {

//   final Movie movie;

//   const _Slide({required this.movie});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
