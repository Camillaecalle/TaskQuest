import 'package:flutter/material.dart';
import 'components/const/colors.dart';
import 'components/button_widget.dart';
import 'sign_up_ui.dart';
import 'task_manager_page.dart';

class AuthenticationUI extends StatefulWidget {
  @override
  _AuthenticationUIState createState() => _AuthenticationUIState();
}

class _AuthenticationUIState extends State<AuthenticationUI> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
        backgroundColor: primaryGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/task_quest.png',
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 32),
              // Email input
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreen),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: secondaryGreen),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Password input
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreen),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: secondaryGreen),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Sign In Button
              ButtonWidget(
                text: 'Sign In',
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Data')),
                    );

                    // Navigate to the TaskManagerPage after sign-in
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskManagerPage()),
                    );
                  }
                },
              ),

              SizedBox(height: 20), // adding space between button and text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpUI()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
