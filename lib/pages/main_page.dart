import 'package:flutter/material.dart';
import 'package:movie_wave/models/movie_model.dart';
import 'package:movie_wave/services/movie_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<MovieModel> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  // This method fetches the upcoming movies  from the API and this method is
  // called in the init state
  Future<void> fetchMovies() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    // rate limiting and avoid frequently calling api requests
    await Future.delayed(Duration(seconds: 1));

    try {
      final newMovies =
          await MovieService().fetchUpcomingMovies(page: _currentPage);
      setState(() {
        if (newMovies.isEmpty) {
          _hasMore = false;
        } else {
          _movies.addAll(newMovies);
          _currentPage++;
        }
      });
    } catch (err) {
      print("Error : $err");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MovieWave",
          style: TextStyle(
            color: Colors.redAccent,
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (!_isLoading &&
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            fetchMovies();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _movies.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            // now all movies were loaded, let show the circular indicator until
            // load the movies from api
            if (index == _movies.length) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.redAccent,
                  ),
                ),
              );
            }
            return ListTile(
              title: Text(
                _movies[index].title.toString(),
              ),
            );
          },
        ),
      ),
    );
  }
}
