import 'package:flutter/material.dart';
import 'package:flutter_movies/src/pages/home_page.dart';
import 'package:flutter_movies/src/pages/movie_detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Películas',
      initialRoute: '/',
      routes: {
        '/'       : (BuildContext context) => HomePage(),
        'detail' : (BuildContext context) => MovieDetail()
      },
    );
  }
}