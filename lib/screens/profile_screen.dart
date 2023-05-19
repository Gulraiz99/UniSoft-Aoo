import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userName = currentUser?.displayName ?? '';
    final userEmail = currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            CircleAvatar(
              radius: 50.0,
              child: Icon(
                Icons.person,
                size: 50.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              userName,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              userEmail,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('Change password'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Language'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.notifications_none),
              title: Text('Notifications'),
              onTap: () {},
            ),
            Spacer(),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    side: BorderSide(color: Colors.blue, width: 2.0),
                    primary: Colors.white,
                    onPrimary: Colors.blue,
                  ),
                  child: Text(
                    'Log out',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
