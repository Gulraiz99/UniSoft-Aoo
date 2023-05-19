import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'createproject_screen.dart';
import 'main_project_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userRole = '';
  bool isProjectManager = false;
  List<String> developerProjects = [];

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  _getUserRole() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser!.uid;
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() {
      userRole = snapshot.data()!['category'];
      isProjectManager = userRole == 'Project Manager';
    });
    if (!isProjectManager) {
      final projectsSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('developers', arrayContains: userId)
          .get();
      setState(() {
        developerProjects = projectsSnapshot.docs.map((doc) => doc.id).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              icon: Icon(Icons.person_2_rounded))
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('projects').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final projects = snapshot.data!.docs;

                if (projects.isNotEmpty) {
                  return Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: projects.map((project) {
                      final projectName = project['name'];
                      final projectType = project['type'];
                      final projectColor = Colors.primaries[
                          projects.indexOf(project) % Colors.primaries.length];

                      return Container(
                        width: MediaQuery.of(context).size.width / 2 - 24.0,
                        decoration: BoxDecoration(
                          color: projectColor,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainProjectScreen(
                                    projectId: project.id,
                                    projectName: projectName,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    projectName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    projectType,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Center(
                    child: Text(
                      'You have not created any projects yet.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Failed to load projects: ${snapshot.error}'),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: userRole == 'Project Manager'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateProjectScreen()),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
