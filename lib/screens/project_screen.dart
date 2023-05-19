import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectScreen extends StatefulWidget {
  final String projectId;

  ProjectScreen({required this.projectId});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _projectStream;

  @override
  void initState() {
    super.initState();
    _projectStream = FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFFAA96DA), // Updated to #aa96da
        scaffoldBackgroundColor: Colors.grey[900], // Updated to #aa96da
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Project Details'),
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _projectStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error loading project details'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data?.data() == null) {
              return Center(child: Text('Project not found'));
            }

            final projectData = snapshot.data!.data()!;
            final subTeamsRef = FirebaseFirestore.instance
                .collection('projects')
                .doc(widget.projectId)
                .collection('subteams');
            final issuesRef = FirebaseFirestore.instance
                .collection('projects')
                .doc(widget.projectId)
                .collection('issues');

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Sub Teams',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: subTeamsRef.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error loading sub teams'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final documents = snapshot.data?.docs ?? [];

                      if (documents.isEmpty) {
                        return Center(
                          child: Text(
                            'No sub teams available',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 1.0,
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final subTeam = documents[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              color: Colors.purple, // Updated color to purple
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      subTeam['name'] ?? '',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Members: ${subTeam['members'] ?? ''}',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32.0),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Issues',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: issuesRef.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error loading issues'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final documents = snapshot.data?.docs ?? [];

                      if (documents.isEmpty) {
                        return Center(
                          child: Text(
                            'No issues available',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final issue = documents[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: Colors.green, // Updated color to green
                            margin: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    issue['type'] ?? '',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    issue['description'] ?? '',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
