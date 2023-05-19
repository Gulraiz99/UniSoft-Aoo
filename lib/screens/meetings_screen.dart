// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MeetingsScreen extends StatefulWidget {
//   final String projectId;

//   MeetingsScreen({required this.projectId});

//   @override
//   _MeetingsScreenState createState() => _MeetingsScreenState();
// }

// class _MeetingsScreenState extends State<MeetingsScreen> {
//   final _channelController = TextEditingController();

//   @override
//   void dispose() {
//     _channelController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleCameraAndMicPermissions() async {
//     await Permission.camera.request();
//     await Permission.microphone.request();
//   }

//   Future<void> _joinMeeting() async {
//     await _handleCameraAndMicPermissions();

//     if (_channelController.text.isNotEmpty) {
//       // Navigate to the video conference screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => VideoConferenceScreen(
//             channelName: _channelController.text,
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Meetings'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _channelController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Channel Name',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _joinMeeting,
//               child: Text('Join Meeting'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VideoConferenceScreen extends StatefulWidget {
//   final String channelName;

//   VideoConferenceScreen({required this.channelName});

//   @override
//   _VideoConferenceScreenState createState() => _VideoConferenceScreenState();
// }

// class _VideoConferenceScreenState extends State<VideoConferenceScreen> {
//   late RtcEngine _engine;

//   @override
//   void initState() {
//     super.initState();
//     _initializeAgoraEngine();
//   }

//   @override
//   void dispose() {
//     _engine.leaveChannel();
//     _engine.destroy();
//     super.dispose();
//   }

//   Future<void> _initializeAgoraEngine() async {
//     _engine = await RtcEngine.createWithConfig(
//       RtcEngineConfig('f82de3e7a8fe499fa6d5583bc92c55af'),
//     );
//     await _engine.enableVideo();

//     await _engine.joinChannel(
//       null,
//       widget.channelName,
//       null,
//       0,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Conference'),
//       ),
//       body: Center(
//         child: Text('Video Conference Screen'),
//       ),
//     );
//   }
// }
