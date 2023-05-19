import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  final String projectId;

  SettingsScreen({required this.projectId});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _projectNameController;
  late TextEditingController _projectDescriptionController;

  @override
  void initState() {
    super.initState();
    _projectNameController = TextEditingController();
    _projectDescriptionController = TextEditingController();
    _loadProjectData();
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectDescriptionController.dispose();
    super.dispose();
  }

  void _loadProjectData() async {
    final projectDoc =
        FirebaseFirestore.instance.collection('projects').doc(widget.projectId);
    final projectSnapshot = await projectDoc.get();

    if (projectSnapshot.exists) {
      final projectData = projectSnapshot.data() as Map<String, dynamic>;
      _projectNameController.text = projectData['name'] ?? '';
      _projectDescriptionController.text = projectData['description'] ?? '';
    }
  }

  void _updateProject() async {
    final projectDoc =
        FirebaseFirestore.instance.collection('projects').doc(widget.projectId);
    await projectDoc.update({
      'name': _projectNameController.text,
      'description': _projectDescriptionController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Project updated successfully')),
    );
  }

  void _deleteProject() async {
    final projectDoc =
        FirebaseFirestore.instance.collection('projects').doc(widget.projectId);
    await projectDoc.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Project deleted successfully')),
    );
    // Navigate back to the previous screen or perform any other desired action
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _projectNameController,
              decoration: InputDecoration(labelText: 'Project Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _projectDescriptionController,
              decoration: InputDecoration(labelText: 'Project Description'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _updateProject,
              child: Text('Update Project'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _deleteProject,
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text('Delete Project'),
            ),
          ],
        ),
      ),
    );
  }
}
