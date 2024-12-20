import 'package:flutter/material.dart';
import 'package:movie_wave/models/tv_shows_model.dart';
import 'package:movie_wave/services/tv_shows_services.dart';
import 'package:movie_wave/widgets/tv_show_widget.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  List<TVShowsModel> _tvShows = [];
  bool _isLoading = false;
  String _error = "";

  // Fetch tv shows
  Future<void> _fetchTVShows() async {
    try {
      List<TVShowsModel> tvShows = await TVShowsServices().fetchTVShows();
      setState(() {
        _tvShows = tvShows;
        _isLoading = false;
      });
    } catch (err) {
      print("Error :$err");
      setState(() {
        _error = "Failed to load tv shows";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTVShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TV Shows"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.redAccent,
            ))
          : _error.isNotEmpty
              ? Center(
                  child: Center(child: Text(_error)),
                )
              : ListView.builder(
                  itemCount: _tvShows.length,
                  itemBuilder: (context, index) {
                    return TvShowWidget(tvShow: _tvShows[index]);
                  },
                ),
    );
  }
}
