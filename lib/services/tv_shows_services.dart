import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_wave/models/tv_shows_model.dart';

import 'package:http/http.dart' as http;

class TVShowsServices {
  final String _apiKey = dotenv.env["TMDB_API_KEY"] ?? "";

  Future<List<TVShowsModel>> fetchTVShows() async {
    try {
      // Popular tv shows
      final popularResponse = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/tv/popular?api_key=$_apiKey"));

      // airing today tv shows
      final airingResponse = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/tv/airing_today?api_key=$_apiKey"));

      //top rated tv shows
      final topRatedResponse = await http.get(Uri.parse("https://api.themoviedb.org/3/tv/top_rated?api_key=$_apiKey"));

      if(popularResponse.statusCode == 200 && airingResponse.statusCode ==200 && topRatedResponse.statusCode == 200){
        final popularData = json.decode(popularResponse.body);
        final airingData = json.decode(popularResponse.body);
        final topRatedData = json.decode(popularResponse.body);

        final List<dynamic> popularResult = popularData["results"];
        final List<dynamic> airingResult = airingData["results"];
        final List<dynamic>topRatedResult = topRatedData["results"];

        List<TVShowsModel> tvShows = [];

        tvShows.addAll(popularResult.map((tvData) => TVShowsModel.fromJson(tvData)).take(10));
        tvShows.addAll(airingResult.map((tvData) => TVShowsModel.fromJson(tvData)).take(10));
        tvShows.addAll(topRatedResult.map((tvData) => TVShowsModel.fromJson(tvData)).take(10));

        return tvShows;
      } else {
        throw Exception("Failed to load tv shows");
      }
    } catch (err) {
      print("Error fetching tv shows : $err");
      return [];
    }
  }
}
