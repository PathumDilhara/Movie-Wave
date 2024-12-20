import 'package:flutter/material.dart';
import 'package:movie_wave/models/movie_model.dart';
import 'package:movie_wave/services/movie_service.dart';
import 'package:movie_wave/widgets/search_details_widget.dart';

class SingleMovieDetailsPage extends StatefulWidget {
  MovieModel movie;
  SingleMovieDetailsPage({
    super.key,
    required this.movie,
  });

  @override
  State<SingleMovieDetailsPage> createState() => _SingleMovieDetailsPageState();
}

class _SingleMovieDetailsPageState extends State<SingleMovieDetailsPage> {
  List<MovieModel> _similarMovies = [];
  List<MovieModel> _recommendedMovies = [];
  List<String> _movieImages = [];

  bool _isLoadingSimilar = true;
  bool _isLoadingRecommended = true;
  bool _isLoadingImages = true;

  // fetch similar movies
  Future<void> _fetchSimilarMovies() async {
    try {
      List<MovieModel> fetchedMovies =
          await MovieService().fetchSimilarMovies(widget.movie.id);
      setState(() {
        _similarMovies = fetchedMovies;
        _isLoadingSimilar = false;
      });
    } catch (err) {
      print("Error fetching similar movies $err");
      _isLoadingSimilar = false;
    }
  }

  // fetch recommended movies
  Future<void> _fetchRecommendedMovies() async {
    try {
      List<MovieModel> recommendedMovies =
          await MovieService().fetchRecommendedMovies(widget.movie.id);
      setState(() {
        _recommendedMovies = recommendedMovies;
        _isLoadingRecommended = false;
      });
    } catch (err) {
      print("Error fetching recommended movies $err");
      setState(() {
        _isLoadingRecommended = false;
      });
    }
  }

  // fetch movie images
  Future<void> _fetchMovieImages() async {
    try {
      List<String> fetchedImages =
          await MovieService().fetchImageFromMovieId(widget.movie.id);
      setState(() {
        _movieImages = fetchedImages;
        _isLoadingImages = false;
      });
    } catch (err) {
      print("Error fetching movie images $err");
      setState(() {
        _isLoadingImages = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchSimilarMovies();
    _fetchRecommendedMovies();
    _fetchMovieImages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchDetailsWidget(movie: widget.movie),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Movie Images",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildImageSection(),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),

              // Similar Movies
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Similar Movies",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildMovieSection(_similarMovies, _isLoadingSimilar),

              // Recommended moves
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Recommended Movies",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildMovieSection(_recommendedMovies, _isLoadingRecommended),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    if (_isLoadingImages) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.redAccent,
        ),
      );
    }
    if (_movieImages.isEmpty) {
      return Center(
        child: Text("No images found"),
      );
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _movieImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                _movieImages[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieSection(List<MovieModel> movies, bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.redAccent,
        ),
      );
    }
    if (movies.isEmpty) {
      return Center(
        child: Text("No movies found"),
      );
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                //  select one from similar or recommended we go to again this class using another movie
                widget.movie = movies[index];
                _fetchSimilarMovies();
                _fetchRecommendedMovies();
                _fetchMovieImages();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(3),
              ),
              margin: EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (movies[index].posterPath != null)
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.network(
                            "https://image.tmdb.org/t/p/w500/${movies[index].posterPath}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        movies[index].title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      "Average Vote : ${movies[index].voteAverage}",
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.red[600],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
