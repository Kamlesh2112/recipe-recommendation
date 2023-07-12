# recipe-recommendation
Recipe Recommendation Based on ingredients App
This is a recipe recommendation app that allows users to select ingredients and get recipe recommendations based on their selections. The app integrates with the Edamam API to fetch recipe data.

Features
User Authentication: Users can create accounts and log in using their email and password. Firebase Authentication is used for user authentication.

Ingredient Selection: Users can select ingredients from a list of available options. The selected ingredients are used to fetch recipe recommendations.

Recipe Recommendations: The app makes a request to the Edamam API with the selected ingredients and retrieves a list of recommended recipes. The recommended recipes are displayed to the user.

Prerequisites
Flutter SDK: Make sure you have Flutter SDK installed on your machine. You can download it from the official Flutter website.

Firebase Project: You need to set up a Firebase project and obtain the necessary configuration files (google-services.json for Android, GoogleService-Info.plist for iOS) 
to enable Firebase authentication in the app. Refer to the Firebase documentation for more information.

Edamam API Key: Obtain an API key from the Edamam website to make requests to their API. Make sure to replace the placeholders in the code with your actual API key.

Getting Started
Clone the repository to your local machine.

Set up Firebase: Add the Firebase configuration files (google-services.json for Android, GoogleService-Info.plist for iOS) to the respective platform folders in the project.

Update API Key: Open the lib/home_screen.dart file and replace the appId and appKey variables with your Edamam API credentials.

Run the App: Connect a device or start an emulator, and run the app using the flutter run command.

Folder Structure
lib/: Contains the Dart code for the app.
main.dart: Entry point of the app.
firebase_options.dart: Contains the Firebase configuration options.
login_screen.dart: Displays the login form.
register_screen.dart: Displays the registration form.
home_screen.dart: Allows users to select ingredients and view recipe recommendations.
recommendations_screen.dart: Displays the recommended recipes.
ingredient_chip.dart: Represents a single ingredient chip.
recipe.dart: Defines the Recipe class representing a recipe model.
Dependencies
The app uses the following dependencies:

firebase_core: Provides Firebase core functionality.
firebase_auth: Enables Firebase authentication.
http: Allows making HTTP requests.
flutter/material.dart: Provides the Material Design widgets for the app UI.

Contributing
Contributions are welcome! If you find any issues or have suggestions for improvement, feel free to create a pull request or submit an issue in the repository.
