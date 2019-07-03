import 'dart:async';
import 'dart:convert';

import 'package:flutter_movies/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider {
  String _apiKey    = '61592a891d9e59dcfd9e3a8ab3eb30cb';
  String _url       = 'api.themoviedb.org';
  String _language  = 'es-ES';

  int _popularesPage = 0;
  bool _loading      = false;

  List<Movie> _populares = new List();

  final _popularesStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Movie>> get popularesStream => _popularesStreamController.stream;

  void disposeStream() {
    _popularesStreamController?.close();
  }

  Future<List<Movie>> _processResponse(Uri url) async {

    final response = await http.get(url);
    final decodedData = json.decode(response.body);

    final movies = new Movies.fromJsonList(decodedData['results']);
    return movies.movies;

  }

  Future<List<Movie>> getNowPlaying() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'   : _apiKey,
      'language'  : _language
    });
    
    return _processResponse(url);

  }

  Future<List<Movie>> getPopular() async {

    if (_loading) return [];

    _loading = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'   : _apiKey,
      'language'  : _language,
      'page'      : _popularesPage.toString()
    });

    final resp = await _processResponse(url);

    _populares.addAll(resp);
    popularesSink(_populares);
    _loading = false;

    return resp;

  }


}