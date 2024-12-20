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

      if (response.statusCode == 200) {
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

  // Search movie by title
  // https://api.themoviedb.org/3/search/movie?query=ice age&api_key=011f78146930034fcaa1c5f6d2f270b5
  Future<List<MovieModel>> searchMovie(String query) async {
    final String _searchUrl = "https://api.themoviedb.org/3/search/movie";
    try {
      final response = await http
          .get(Uri.parse("$_searchUrl?query=$query&api_key=$_apiKey"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data["results"];

        return results.map((movie) => MovieModel.fromJson(movie)).toList();
      } else {
        throw Exception("Error searching movies");
      }
    } catch (err) {
      print("Error : $err");
      throw Exception("Failed to searching movies : $err");
      return [];
    }
  }

  // Similar movies
  Future<List<MovieModel>> fetchSimilarMovies(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$_apiKey"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data["results"];

        return results.map((movie) => MovieModel.fromJson(movie)).toList();
      } else {
        throw Exception("Error fetching similar movies");
      }
    } catch (err) {
      print("Failed to fetch similar movies");
      return [];
    }
  }

  // Similar movies
  Future<List<MovieModel>> fetchRecommendedMovies(int movieId) async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/recommendations?api_key=$_apiKey"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data["results"];

        return results.map((movie) => MovieModel.fromJson(movie)).toList();
      } else {
        throw Exception("Error fetching recommended movies");
      }
    } catch (err) {
      print("Failed to fetch recommended movies");
      return [];
    }
  }

  // Fetch images by movie Id
  Future<List<String>> fetchImageFromMovieId(int movieId) async {
    try {
      final response = await http.get(Uri.parse("https://api.themoviedb.org/3/movie/$movieId/images?api_key=$_apiKey"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> backdrops = data["backdrops"];

        // Extract file path & return the first 10 images
        // backdrop is a list, get first 10 elt then do function using map
        return backdrops.take(10).map((imageData) => "https://image.tmdb.org/t/p/w500/${imageData["file_path"]}").toList();
      } else {
        throw Exception("Error fetching images movies");
      }
    } catch (err) {
      print("Failed to fetch images : $err");
      return [];
    }
  }
}
