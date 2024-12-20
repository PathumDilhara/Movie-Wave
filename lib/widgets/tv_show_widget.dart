import 'package:flutter/material.dart';
import 'package:movie_wave/models/tv_shows_model.dart';

class TvShowWidget extends StatelessWidget {
  final TVShowsModel tvShow;
  const TvShowWidget({
    super.key,
    required this.tvShow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500/${tvShow.posterPath}",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              tvShow.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
            Text(tvShow.overview,style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600]
            ),)
          ],
        ),
      ),
    );
  }
}
