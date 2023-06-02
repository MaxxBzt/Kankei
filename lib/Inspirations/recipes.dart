import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme_system.dart';

class Recipe extends StatefulWidget {
  const Recipe({Key? key}) : super(key: key);

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  final String _apiKey = '3f4dcb9486d247f29137f813b5701b69';
  final List<String> _categories = ['All', 'Italian', 'Mexican', 'Asian'];
  String _selectedCategory = 'All';
  List<dynamic> _recipes = [];
  bool _loading = true;

  Future<void> _fetchRecipes() async {
    setState(() {
      _loading = true;
    });

    String url =
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=$_apiKey&number=50';

    if (_selectedCategory != 'All') {
      url += '&cuisine=$_selectedCategory';
    }

    try {
      final response = await http.get(Uri.parse(url));
      final responseData = jsonDecode(response.body);

      setState(() {
        _recipes = responseData['results'];
        _loading = false;
      });
    } catch (error) {
      setState(() {
        _loading = false;
      });
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: _buildNavigationBar(),
          ),
          SizedBox(height: 15),
          _buildRecipeList(),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    final theme_provider = Provider.of<Theme_Provider>(context);
    bool isAppDarkMode = theme_provider.is_DarkMode;

    final Brightness brightnessValue = MediaQuery.of(context).platformBrightness;
    bool isSystemDarkMode = brightnessValue == Brightness.dark;

    bool is_dark = isAppDarkMode || isSystemDarkMode;

    return Container(
      height: kToolbarHeight,
      color: is_dark ? Colors.black: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.food_bank),
            color: _categories.indexOf(_selectedCategory) == 0
                ? Colors.purple.shade200
                : Colors.grey,
            onPressed: () {
              setState(() {
                _selectedCategory = _categories[0];
              });
              _fetchRecipes();
            },
          ),
          IconButton(
            icon: Icon(Icons.local_pizza),
            color: _categories.indexOf(_selectedCategory) == 1
                ? Colors.purple.shade200
                : Colors.grey,
            onPressed: () {
              setState(() {
                _selectedCategory = _categories[1];
              });
              _fetchRecipes();
            },
          ),
          IconButton(
            icon: Icon(Icons.local_dining),
            color: _categories.indexOf(_selectedCategory) == 2
                ? Colors.purple.shade200
                : Colors.grey,
            onPressed: () {
              setState(() {
                _selectedCategory = _categories[2];
              });
              _fetchRecipes();
            },
          ),
          IconButton(
            icon: Icon(Icons.restaurant),
            color: _categories.indexOf(_selectedCategory) == 3
                ? Colors.purple.shade200
                : Colors.grey,
            onPressed: () {
              setState(() {
                _selectedCategory = _categories[3];
              });
              _fetchRecipes();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList() {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_recipes.isEmpty) {
      return Center(
        child: Text('No recipes found.'),
      );
    } else {
      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          final recipe = _recipes[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: () async {
                final url = recipe['sourceUrl'];
                final Uri url_recipe = Uri.parse(url);
                if (await launchUrl(url_recipe)) {
                  await launchUrl(url_recipe);
                } else {
                  throw 'Could not launch $url_recipe';
                }
              },
              child: ListTile(
                leading: Image.network(recipe['image']),
                title: Text(recipe['title']),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      );
    }
  }
}
