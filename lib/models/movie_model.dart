class MovieModel {
  final bool isAdult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String releaseDate;
  final String title;
  final bool isVideo;
  final double voteAverage;
  final int voteCount;

  MovieModel({
    required this.isAdult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.isVideo,
    required this.voteAverage,
    required this.voteCount,
  });

  // json to dart, considering nullable
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      isAdult: json["adult"] ?? false,
      backdropPath: json["backdrop_path"] as String?, // Since can be null
      genreIds: List<int>.from(json["genre_ids"] ?? [] ),
      id: json["id"] ?? 0,
      originalLanguage: json["original_language"] ?? "",
      originalTitle: json["original_title"] ?? "",
      overview: json["overview"] ?? "",
      popularity: (json["popularity"] ?? 0).toDouble(),
      posterPath: json["poster_path"] as String?,
      releaseDate: json["release_date"] ?? "",
      title: json["title"] ?? "",
      isVideo: json["video"] ?? false,
      voteAverage: (json["vote_average"] ?? 0).toDouble(),
      voteCount: json["vote_count"] ?? 0,
    );
  }
}
