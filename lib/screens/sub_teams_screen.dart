import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubTeamsScreen extends StatefulWidget {
  final String projectId;

  const SubTeamsScreen({Key? key, required this.projectId}) : super(key: key);

  @override
  _SubTeamsScreenState createState() => _SubTeamsScreenState();
}

class _SubTeamsScreenState extends State<SubTeamsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  List<String> _selectedMembers = [];
  List<bool> _selectedUsers = [];
  late String currentUserEmail;
  List<String> _selectedMemberIds = [];

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    currentUserEmail = user!.email!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Sub-Team'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter the name of the sub-team',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for the sub-team';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text('Members'),
              SizedBox(height: 8.0),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('developers')
                    .orderBy('email')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  List<Widget> memberWidgets = [];
                  snapshot.data!.docs.forEach((doc) {
                    final memberId = doc.id;
                    final memberEmail = doc['email'];
                    final index = _selectedMembers.indexOf(memberEmail);
                    final isSelected =
                        index >= 0 ? _selectedUsers[index] : false;
                    memberWidgets.add(CheckboxListTile(
                      title: Text(memberEmail),
                      value: isSelected,
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _selectedMembers.add(memberEmail);
                            _selectedUsers.add(true);
                          } else {
                            _selectedUsers[index] = false;
                            _selectedMembers.removeAt(index);
                            _selectedUsers.removeAt(index);
                          }
                        });
                      },
                    ));
                    _selectedMemberIds.add(memberId);
                  });
                  return Column(children: memberWidgets);
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Get the userIds and emails of selected members
                      final selectedMembers = await Future.wait(
                          _selectedMembers.map((member) async {
                        final userDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: member)
                            .get();
                        final user = userDoc.docs.first;
                        return {
                          'email': member,
                          'userId': user.id,
                        };
                      }));
                      final selectedMemberIds = selectedMembers
                          .where((member) =>
                              _selectedMembers.contains(member['email']))
                          .map((member) => member['userId'])
                          .toList();

                      // Save the sub-team with the selected members and their userIds
                      await FirebaseFirestore.instance
                          .collection('projects')
                          .doc(widget.projectId)
                          .collection('subteams')
                          .add({
                        'name': _nameController.text,
                        'members': _selectedMembers,
                        'memberIds': selectedMemberIds,
                      });
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: Text('Create Sub-Team'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
