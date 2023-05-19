import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IssuesScreen extends StatefulWidget {
  final String projectId;

  IssuesScreen({required this.projectId});

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  late final String _userName;
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedType;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    _userName = currentUser!.displayName ?? 'unknown user';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created by: $_userName',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter issue description',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            Text(
              'Select issue type:',
              style: TextStyle(fontSize: 16.0),
            ),
            Row(
              children: [
                Radio(
                  value: 'bug',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value as String?;
                    });
                  },
                ),
                Text('Bug'),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 'task',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value as String?;
                    });
                  },
                ),
                Text('Task'),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 'issue',
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value as String?;
                    });
                  },
                ),
                Text('Issue'),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Select issue priority:',
              style: TextStyle(fontSize: 16.0),
            ),
            Row(
              children: [
                Radio(
                  value: 'high',
                  groupValue: _selectedPriority,
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value as String?;
                    });
                  },
                ),
                Text('High'),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 'medium',
                  groupValue: _selectedPriority,
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value as String?;
                    });
                  },
                ),
                Text('Medium'),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 'low',
                  groupValue: _selectedPriority,
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value as String?;
                    });
                  },
                ),
                Text('Low'),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final currentUser = FirebaseAuth.instance.currentUser;
                final createdBy = currentUser!.displayName ?? currentUser.email;
                final projectId = widget.projectId;
                final type = _selectedType;
                final description = _descriptionController.text;
                final priority = _selectedPriority;

                createIssue(
                  projectId,
                  type,
                  description,
                  priority,
                ).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Issue added to project.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error adding issue: $error'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              },
              child: Text('Create Issue'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> createIssue(String projectId, String? issueType,
    String issueDescription, String? issuePriority) async {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userId = currentUser.uid;
  final userName = currentUser.displayName ?? 'unknown user';

  await FirebaseFirestore.instance
      .collection('projects')
      .doc(projectId)
      .collection('issues')
      .add({
    'type': issueType,
    'description': issueDescription,
    'priority': issuePriority,
    'createdBy': userName,
    'userId': userId,
    'createdAt': FieldValue.serverTimestamp(),
  });
}
