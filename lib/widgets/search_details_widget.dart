import 'package:flutter/material.dart';
import 'package:movie_wave/models/movie_model.dart';

class SearchDetailsWidget extends StatelessWidget {
  final MovieModel movie;
  const SearchDetailsWidget({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),

            // Title
            Text(
              movie.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),

            // Release Date
            Text(
              "Release Date : ${movie.releaseDate}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.red[600],
              ),
            ),
            SizedBox(
              height: 5,
            ),

            // Overview
            Text(
              "Overview",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              movie.overview,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Average Vote : ${movie.voteAverage}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red[600],
                  ),
                ),
                Text(
                  "Popularity : ${movie.popularity}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Divider()
          ],
        ),
      ),
    );
  }
}
