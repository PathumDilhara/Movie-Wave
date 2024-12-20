import 'package:flutter/material.dart';
import 'package:movie_wave/models/movie_model.dart';
import 'package:movie_wave/services/movie_service.dart';
import 'package:movie_wave/widgets/search_details_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<MovieModel> _searchResults = [];
  bool _isLoading = false;
  String _error = "";

  // Method to call the search end point
  Future<void> _searchMovies() async {
    setState(() {
      _isLoading = true;
      _error = "";
    });
    try {
      List<MovieModel> movies =
          await MovieService().searchMovie(_searchController.text);
      setState(() {
        _searchResults = movies;
      });
    } catch (err) {
      print("Error : $err");
      setState(() {
        _error = "Failed to search for that movie";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Movies"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: _searchResults.isEmpty ? MediaQuery.of(context).size.height * 0.3 : 1),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search for a movie",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _searchMovies(),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.redAccent, shape: BoxShape.circle),
                    child: IconButton(
                      onPressed: _searchMovies,
                      icon: Icon(
                        Icons.search,
                        size: 30,
                        weight: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                ),
              )
            else if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  _error,
                  style: TextStyle(color: Colors.red),
                ),
              )
            else if (_searchResults.isEmpty)
              Center(
                child: Text(
                  "No movies found please search....",
                  style: TextStyle(fontSize: 16),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SearchDetailsWidget(movie: _searchResults[index]),
                      ],
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
