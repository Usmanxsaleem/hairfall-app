import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.teal, // Theme color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.tealAccent], // Background gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Profile Section
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.teal),
              title: const Text('Profile'),
              subtitle: const Text('View and edit your profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
            ),
            const Divider(),

            // Notification Settings
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Receive notifications from the app'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              secondary: const Icon(Icons.notifications, color: Colors.teal),
              activeColor: Colors.teal,
            ),
            const Divider(),

            // Dark Mode Toggle
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Enable dark mode for the app'),
              value: _darkModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
              secondary: const Icon(Icons.dark_mode, color: Colors.teal),
              activeColor: Colors.teal,
            ),
            const Divider(),

            // Language Preferences
            ListTile(
              leading: const Icon(Icons.language, color: Colors.teal),
              title: const Text('Language'),
              subtitle: Text('Current: $_selectedLanguage'),
              onTap: () {
                _showLanguagePicker();
              },
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
            ),
            const Divider(),

            // Account Settings
            ListTile(
              leading: const Icon(Icons.security, color: Colors.teal),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.pushNamed(context, '/change_password');
              },
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
            ),
            const Divider(),

            // About Section
            ListTile(
              leading: const Icon(Icons.info, color: Colors.teal),
              title: const Text('About'),
              subtitle: const Text('App version 1.0.0'),
              onTap: () {
                // Show app info
              },
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal),
            ),
            const Divider(),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // Language Picker Dialog
  void _showLanguagePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: DropdownButton<String>(
            value: _selectedLanguage,
            items: <String>['English', 'Spanish', 'French', 'German']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
