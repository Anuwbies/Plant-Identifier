import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPageModel extends ChangeNotifier {
  String firstName = "";
  String lastName = "";
  String emailText = "";
  String joinedDate = "";

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final fName = prefs.getString('first_name');
    final lName = prefs.getString('last_name');
    final email = prefs.getString('email');
    final date = prefs.getString('joined_date');

    if (fName != null && lName != null && email != null && date != null) {
      firstName = fName;
      lastName = lName;
      emailText = email;
      joinedDate = date;
    } else {
      firstName = "";
      lastName = "";
      emailText = "";
      joinedDate = "";
    }
    notifyListeners();
  }

  Color getRandomDarkColor() {
    final Random random = Random();
    int r = random.nextInt(150);
    int g = random.nextInt(150);
    int b = random.nextInt(150);
    return Color.fromARGB(255, r, g, b);
  }

  Future<void> logout(BuildContext context, Future<void> Function() clearPrefs, VoidCallback navigateToWelcome) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Confirm Log Out',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Are you sure you want to log out?',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white10,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child:
                    const Text('Log Out', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirm == true) {
      await clearPrefs();
      navigateToWelcome();
    }
  }
}
