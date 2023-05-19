import 'package:flutter/material.dart';
import 'package:unisoft_app/screens/chat_screen.dart';
import 'package:unisoft_app/screens/issues_screen.dart';
import 'package:unisoft_app/screens/meetings_screen.dart';
import 'package:unisoft_app/screens/project_screen.dart';
import 'package:unisoft_app/screens/settings_screen.dart';
import 'package:unisoft_app/screens/sub_teams_screen.dart';

class MainProjectScreen extends StatefulWidget {
  final String projectId;
  final String projectName;
  MainProjectScreen({required this.projectId, required this.projectName});

  @override
  _MainProjectScreenState createState() => _MainProjectScreenState();
}

class _MainProjectScreenState extends State<MainProjectScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 46, 109, 141),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Issues',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Sub Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Meetings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return ProjectScreen(projectId: widget.projectId);
      case 1:
        return IssuesScreen(projectId: widget.projectId);
      case 2:
        return SubTeamsScreen(
          projectId: widget.projectId,
        );
      case 3:
        return ChatScreen(projectId: widget.projectId);
      case 4:
      // return MeetingsScreen(projectId: widget.projectId);
      case 5:
        return SettingsScreen(projectId: widget.projectId);
      default:
        return Container();
    }
  }
}
