import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_colors.dart';
import '../theme/theme_system.dart';

class PopularMoviesAndShows extends StatefulWidget {
  @override
  _PopularMoviesAndShowsState createState() => _PopularMoviesAndShowsState();
}

class _PopularMoviesAndShowsState extends State<PopularMoviesAndShows> {
  List _popularItems = [];

  @override
  void initState() {
    super.initState();
    _fetchPopularItems();
  }

  Future<void> _fetchPopularItems() async {
    String apiKey = '2376c1599a4ed2b7d3720ca1ad867c1f';
    String apiUrl =
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=1';
    http.Response response = await http.get(Uri.parse(apiUrl));
    Map<String, dynamic> data = json.decode(response.body);
    setState(() {
      _popularItems = data['results'];
    });
  }

// Helper method to launch a URL in a browser
  Future<void> _launchURL(String url) async {
    final Uri url_movie = Uri.parse(url);
    if (await canLaunchUrl(url_movie)) {
      await launchUrl(url_movie);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url_movie'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      itemCount: _popularItems.length,
      itemBuilder: (BuildContext context, int index) {
        String imageUrl =
            'https://image.tmdb.org/t/p/w300${_popularItems[index]['poster_path']}';
        String title = _popularItems[index]['title'];
        int id = _popularItems[index]['id'];
        String tmdbUrl = 'https://www.themoviedb.org/movie/$id';
        return Card(
          shape: const RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xFFEAE7FA),
              width: 4,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: is_dark ? AppColors.dark_appbar_header : Color(0xFFb087bf),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => _launchURL(tmdbUrl),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center, // center the text
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          ),
        );
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
