import 'dart:convert';

import 'package:example_package/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReRe',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ReRe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ),
              obscureText: !showPassword,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  String email = emailController.text;
                  String password = passwordController.text;
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  // Login successful, navigate to the home screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                } catch (e) {
                  setState(() {
                    errorMessage = 'Wrong password. Please try again.';
                  });
                  print(e.toString());
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(),
                  ),
                );
              },
              child: Text('Create an account'),
            ),
            Visibility(
              visible: errorMessage.isNotEmpty,
              child: Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ),
              obscureText: !showPassword,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  String email = emailController.text;
                  String password = passwordController.text;
                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  // Registration successful, navigate to the home screen or perform additional actions
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                } catch (e) {
                  setState(() {
                    errorMessage = 'User already exists with this email.';
                  });
                  print(e.toString());
                }
              },
              child: Text('Register'),
            ),
            Visibility(
              visible: errorMessage.isNotEmpty,
              child: Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedIngredients = [];

  void _selectIngredient(String ingredient) {
    setState(() {
      if (selectedIngredients.contains(ingredient)) {
        selectedIngredients.remove(ingredient);
      } else {
        selectedIngredients.add(ingredient);
      }
    });
  }

  void _recommendRecipes() async {
    final appId = 'Edmam Api Key';
    final appKey = 'Edmam Api Key';

    final queryParameters = {
      'app_id': appId,
      'app_key': appKey,
      'q': selectedIngredients.join(','),
    };

    final uri = Uri.https('api.edamam.com', '/search', queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> recipeList = data['hits'];
      List<Recipe> recommendedRecipes = recipeList.map((recipe) => Recipe.fromJson(recipe['recipe'])).toList();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendationsScreen(recipes: recommendedRecipes),
        ),
      );
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ReRe',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Select Ingredients',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    IngredientChip(
                      ingredient: 'black pepper',
                      isSelected: selectedIngredients.contains('black pepper'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'cumin',
                      isSelected: selectedIngredients.contains('cumin'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'coriander',
                      isSelected: selectedIngredients.contains('coriander'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'bay leaves',
                      isSelected: selectedIngredients.contains('bay leaves'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'paprika',
                      isSelected: selectedIngredients.contains('paprika'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'cayenne',
                      isSelected: selectedIngredients.contains('cayenne'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'fennel',
                      isSelected: selectedIngredients.contains('fennel'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'turmeric',
                      isSelected: selectedIngredients.contains('turmeric'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'cinnamon',
                      isSelected: selectedIngredients.contains('cinnamon'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'nutmeg',
                      isSelected: selectedIngredients.contains('nutmeg'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'thyme',
                      isSelected: selectedIngredients.contains('thyme'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'oregano',
                      isSelected: selectedIngredients.contains('oregano'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'chili flakes',
                      isSelected: selectedIngredients.contains('chili flakes'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'chili powder',
                      isSelected: selectedIngredients.contains('chili powder'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'salt',
                      isSelected: selectedIngredients.contains('salt'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'instant yeast',
                      isSelected: selectedIngredients.contains('instant yeast'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'baking powder',
                      isSelected: selectedIngredients.contains('baking powder'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'baking soda',
                      isSelected: selectedIngredients.contains('baking soda'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'cane sugar',
                      isSelected: selectedIngredients.contains('cane sugar'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'brown sugar',
                      isSelected: selectedIngredients.contains('brown sugar'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'powdered sugar',
                      isSelected: selectedIngredients.contains('powdered sugar'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'panko breadcrumbs',
                      isSelected: selectedIngredients.contains('panko breadcrumbs'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'dry beans',
                      isSelected: selectedIngredients.contains('dry beans'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'grains',
                      isSelected: selectedIngredients.contains('grains'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'pasta',
                      isSelected: selectedIngredients.contains('pasta'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'chicken',
                      isSelected: selectedIngredients.contains('chicken'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'beef',
                      isSelected: selectedIngredients.contains('beef'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'fish',
                      isSelected: selectedIngredients.contains('fish'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'tomatoes',
                      isSelected: selectedIngredients.contains('tomatoes'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'tomato paste',
                      isSelected: selectedIngredients.contains('tomato paste'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'cooking oil',
                      isSelected: selectedIngredients.contains('cooking oil'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'vegetable oil',
                      isSelected: selectedIngredients.contains('vegetable oil'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'avocado oil',
                      isSelected: selectedIngredients.contains('avocado oil'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'canola oil',
                      isSelected: selectedIngredients.contains('canola oil'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'extra virgin oil',
                      isSelected: selectedIngredients.contains('extra virgin oil'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'toasted sesame oil',
                      isSelected: selectedIngredients.contains('toasted sesame oil'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'vinegar',
                      isSelected: selectedIngredients.contains('vinegar'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'red wine',
                      isSelected: selectedIngredients.contains('red wine'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'apple cider vinegar',
                      isSelected: selectedIngredients.contains('apple cider vinegar'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'balsamic vinegar',
                      isSelected: selectedIngredients.contains('balsamic vinegar'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'white wine',
                      isSelected: selectedIngredients.contains('white wine'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'honey',
                      isSelected: selectedIngredients.contains('honey'),
                      onTap: _selectIngredient,
                    ),
                    IngredientChip(
                      ingredient: 'maple syrup',
                      isSelected: selectedIngredients.contains('maple syrup'),
                      onTap: _selectIngredient,
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: selectedIngredients.isNotEmpty ? _recommendRecipes : null,
                  child: Text('Recommend Recipes'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class IngredientChip extends StatelessWidget {
  final String ingredient;
  final bool isSelected;
  final Function(String) onTap;

  IngredientChip({
    required this.ingredient,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(ingredient),
      child: Chip(
        label: Text(
          ingredient,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isSelected ? Colors.orange : Colors.grey[300],
      ),
    );
  }
}

class RecommendationsScreen extends StatelessWidget {
  final List<Recipe> recipes;

  RecommendationsScreen({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recommendations',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe.title),
            subtitle: Text('Ready in ${recipe.totalTime} minutes'),
          );
        },
      ),
    );
  }
}

class Recipe {
  final String title;
  final int totalTime;

  Recipe({required this.title, required this.totalTime});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['label'],
      totalTime: json['totalTime'],
    );
  }
}
