class TVShowsModel {
  final String name;
  final String? posterPath;
  final String overview;
  final double voteAverage;
  final String firstAirDate;

  TVShowsModel({
    required this.name,
    this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.firstAirDate,
  });

  // Json to dart, considering nullable
  factory TVShowsModel.fromJson(Map<String, dynamic> json) {
    return TVShowsModel(
      name: json["name"] ?? "",
      posterPath: json["poster_path"] as String?, // Since can be nullable
      overview: json["overview"] ?? "",
      voteAverage: (json["vote_average"] ?? 0).toDouble(),
      firstAirDate: json["first_air_date"] ?? "",
    );
  }
}
