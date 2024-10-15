import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'model_integration_page.dart'; // Ensure this is the correct file name for the model integration

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyCdXTzupixtZAguHqx_jnDj9lfkj5cX2l8',
      appId: '1:371749157982:android:6b75fd51a0f3bcacea48cf',
      messagingSenderId: '371749157982',
      projectId: 'fir-2-20108',
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Setting the initial route to the login page
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        '/model': (context) => ModelIntegrationPage(), // Route for model integration page
      },
    );
  }
}
