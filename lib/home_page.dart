import 'package:flutter/material.dart';
import 'image_upload_page.dart'; // Import your ImageUploadPage
import 'settings_page.dart';
import 'view_history_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.teal, // Customize the AppBar color
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.tealAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or image
            Image.asset(
              'LOGO1.png', // Replace with your image
              height: 100, // Adjust height as needed
            ),
            const SizedBox(height: 40), // Space between image and buttons

            // Take/Upload Forehead Picture button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const ImageUploadPage()));
              },
              icon: const Icon(Icons.camera_alt, color: Colors.white), // Add icon
              label: const Text(
                'Take/Upload Forehead Picture',
                style: TextStyle(color: Colors.white), // Change text color to white
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.teal, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between buttons

            // Settings button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
              icon: const Icon(Icons.settings, color: Colors.white), // Add icon
              label: const Text(
                'Settings',
                style: TextStyle(color: Colors.white), // Change text color to white
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.teal, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between buttons

            // View History button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const ViewHistoryPage()));
              },
              icon: const Icon(Icons.history, color: Colors.white), // Add icon
              label: const Text(
                'View History',
                style: TextStyle(color: Colors.white), // Change text color to white
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.teal, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
