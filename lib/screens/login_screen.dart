import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_scree.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  bool _isLogoVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isNotEmpty && password.isNotEmpty) {
        try {
          final userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          final user = userCredential.user;

          if (user != null) {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

            if (userDoc.exists) {
              // User has already set their category, navigate to home screen
              Navigator.pushReplacementNamed(
                context,
                '/home',
                arguments: user,
              );
            } else {
              // User has not set their category, show user category screen
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set({
                'email': email,
                'name': user.displayName ?? '',
                'photoUrl': user.photoURL ?? '',
                'userId': user.uid, // Add the user ID here
              });

              Navigator.pushReplacementNamed(
                context,
                '/user-category',
                arguments: user,
              );
            }
          }
        } catch (e) {
          print('Error signing in: $e');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Failed to sign in. Please check your email and password.')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter your email and password.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                if (_isLogoVisible) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
                setState(() {
                  _isLogoVisible = !_isLogoVisible;
                });
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Transform.translate(
                    offset: Offset(0, -_controller.value * 200),
                    child: child,
                  );
                },
                child: Container(
                  width: 300.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/logo.png'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            left: 50,
            right: 50,
            child: AnimatedOpacity(
              opacity: _isLogoVisible ? 0.0 : 1.0,
              duration: Duration(milliseconds: 500),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            labelText: 'Email',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            labelText: 'Password',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: _signIn,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.grey),
                            ),
                          ),
                          child: Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
