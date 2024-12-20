import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_wave/models/movie_model.dart';

import 'package:http/http.dart' as http;

class MovieService {
  // get the api key from .env file
  final String? _apiKey = dotenv.env["TMDB_API_KEY"];
  final String _baseUrl = "https://api.themoviedb.org/3/movie/";

  // fetch all upcoming movies
  Future<List<MovieModel>> fetchUpcomingMovies({int page = 1}) async {
    try {
      final response = await http
          .get(Uri.parse("${_baseUrl}upcoming?api_key=$_apiKey&page=$page"));

      if (response.statusCode == 200) {
        // data - entire json file contain so may things but movie data are in the result key
        final data = json.decode(response.body);
        // separate result key that mapped to a list by using data["results"]
        final List<dynamic> results = data["results"];

        // go though the all items(named movieData) in the list and convert each
        // into MovieModel, finally entire movie model convert into a list
        return results
            .map((movieData) => MovieModel.fromJson(movieData))
            .toList();
      } else {
        throw Exception("Failed load upcoming movies");
      }
    } catch (err) {
      print("Error fetching upcoming movies : $err");
      return [];
    }
  }

  // Now playing movies
  Future<List<MovieModel>> fetchNowPlayingMovie({int page = 1}) async {
    try {
      final response = await http
          .get(Uri.parse("${_baseUrl}now_playing?api_key=$_apiKey&page=$page"));

      if(response.statusCode == 200){
        final data = json.decode(response.body);
        final List<dynamic> result = data["results"];

        return result.map((elt) => MovieModel.fromJson(elt)).toList();
      } else {
        throw Exception("Error fetching now playing movies");
      }
    } catch (err) {
      print("Error fetching now playing movies : $err");
      return [];
    }
  }
}
