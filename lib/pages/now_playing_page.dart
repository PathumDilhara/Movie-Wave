import 'package:flutter/material.dart';
import 'package:movie_wave/models/movie_model.dart';
import 'package:movie_wave/services/movie_service.dart';
import 'package:movie_wave/widgets/movie_details_widget.dart';

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  List<MovieModel> _movies = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;

  // Method to fetch movies from now playing api
  Future<void> _fetchMovies() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<MovieModel> fetchedMovies =
          await MovieService().fetchNowPlayingMovie(page: _currentPage);
      setState(() {
        _movies =
            fetchedMovies; // instead of updating we assign new movies to next page
        _totalPages = 100;
      });
    } catch (err) {
      print("Error : $err");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Previous page
  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchMovies();
    }
  }

  // Next page
  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      _fetchMovies();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Now Playing"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _movies.length + 1,
                    itemBuilder: (context, index) {
                      if (index > _movies.length - 1) {
                        return _buildPaginationControls();
                      } else {
                        return MovieDetailsWidget(movie: _movies[index]);
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _currentPage > 1 ? _previousPage : null,
          child: Text("Previous"),
        ),
        SizedBox(width: 10,),
        Text("Page $_currentPage of $_totalPages"),
        SizedBox(width: 10,),
        ElevatedButton(
          onPressed: _currentPage < _totalPages ? _nextPage : null,
          child: Text("Next"),
        ),
      ],
    );
  }
}
