import 'package:flutter/material.dart';
import 'package:flutter_movies/src/models/movie_model.dart';
import 'package:flutter_movies/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {

  String movieSelected = '';
  final moviesProvider = new MoviesProvider();

  final movies = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Supergirl',
    'Wolverine',
    'Capitan America',
    'Ironman'
  ];

  final recentMovies = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Ícono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crear los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(movieSelected),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparece cuando la persona escribe

    // final suggestList = query.isEmpty
    //     ? recentMovies
    //     : movies
    //         .where(
    //             (movie) => movie.toLowerCase().startsWith(query.toLowerCase()))
    //         .toList();

    // return ListView.builder(
    //     itemCount: suggestList.length,
    //     itemBuilder: (context, i) {
    //       return ListTile(
    //         leading: Icon(Icons.movie),
    //         title: Text(suggestList[i]),
    //         onTap: () {
    //           movieSelected = suggestList[i];
    //           showResults(context);
    //         },
    //       );
    //     });

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: moviesProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;
          return ListView(
            children: movies.map((movie) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(movie.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.contain,
                ),
                title: Text(movie.title),
                subtitle: Text(movie.originalTitle),
                onTap: () {
                  close(context, null);
                  movie.uniqueId = '';
                  Navigator.pushNamed(context, 'detail', arguments: movie);
                },
              );
            }).toList()
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );


  }
}
