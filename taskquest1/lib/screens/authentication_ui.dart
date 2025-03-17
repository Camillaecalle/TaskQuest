import 'package:flutter/material.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email input
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
