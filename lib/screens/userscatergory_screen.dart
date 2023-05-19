import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_scree.dart';

class UserCategoryScreen extends StatefulWidget {
  @override
  _UserCategoryScreenState createState() => _UserCategoryScreenState();
}

class _UserCategoryScreenState extends State<UserCategoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedCategory = '';
  void _saveUserCategory() async {
    final user = FirebaseAuth.instance.currentUser;
    final category = _selectedCategory;

    if (user != null && category.isNotEmpty) {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userData = {
        'category': category,
        'name': user.displayName,
        'email': user.email,
        'userId': user.uid, // add user ID to userData
      };

      try {
        // save userData to users collection
        await userDocRef.update(userData);

        // copy userData to developers or project_managers collection
        if (category == 'Project Manager') {
          await FirebaseFirestore.instance
              .collection('project_managers')
              .doc(user.uid)
              .set(userData);
        } else if (category == 'Developer') {
          await FirebaseFirestore.instance
              .collection('developers')
              .doc(user.uid)
              .set(userData);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User category saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: user,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save user category. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        print('Error saving user category: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select User Category'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Project Manager';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: _selectedCategory == 'Project Manager'
                          ? Colors.green
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/project_manager.jpg',
                          height: 100.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Project Manager',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: _selectedCategory == 'Project Manager'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Developer';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: _selectedCategory == 'Developer'
                          ? Colors.green
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/developer.jpg',
                          height: 100.0,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Developer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: _selectedCategory == 'Developer'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _selectedCategory.isEmpty ? null : _saveUserCategory,
              child: Text('Save'),
            ),
            SizedBox(height: 16.0),
            if (_selectedCategory.isNotEmpty)
              Text(
                'You have selected $_selectedCategory',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
