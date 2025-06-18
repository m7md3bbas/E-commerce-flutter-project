import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String email;
  final String createdAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.email,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      address: json['address'],
      email: json['email'],
      createdAt: json['created_at'],
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String firstName = '',
      lastName = '',
      email = '',
      phone = '',
      address = '',
      password = '',
      confirmPassword = '';

  File? _avatar;

  User? registeredUser;
  String? responseMessage;
  bool registrationSuccess = false;
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
    await prefs.setString('password', password);
    if (_avatar != null) {
      await prefs.setString('avatarPath', _avatar!.path);
    }
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('https://ib.jamalmoallart.com/api/v2/register');

      Map<String, dynamic> data = {
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "address": address,
        "email": email,
        "password": password,
      };

      try {
        final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          print(jsonResponse);

          setState(() {
            registrationSuccess = jsonResponse['state'] ?? false;
            responseMessage = jsonResponse['message'] ?? '';

            if (registrationSuccess) {
              registeredUser = User.fromJson(jsonResponse['data']);
            }
          });

          if (registrationSuccess) {
            await saveUserData();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseMessage!)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseMessage ?? 'Registration failed')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Registration failed: ${response.statusCode} ${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        print('Error calling register API: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting to server.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/auth.jpg", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              _avatar != null ? FileImage(_avatar!) : null,
                          child: _avatar == null
                              ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey[700],
                                )
                              : null,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 20,
                          child: IconButton(
                            onPressed: pickImage,
                            icon: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  _styledField(
                    'First Name',
                    onChanged: (val) => firstName = val,
                  ),
                  _styledField(
                    'Last Name',
                    onChanged: (val) => lastName = val,
                  ),
                  _styledField(
                    'Phone',
                    onChanged: (val) => phone = val,
                    keyboardType: TextInputType.phone,
                  ),
                  _styledField(
                    'Address',
                    onChanged: (val) => address = val,
                  ),
                  _styledField(
                    'Email',
                    onChanged: (val) => email = val,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _styledField(
                    'Password',
                    obscureText: true,
                    onChanged: (val) => password = val,
                    validator: (val) =>
                        val != null && val.length < 6 ? 'Min 6 chars' : null,
                  ),
                  _styledField(
                    'Confirm Password',
                    obscureText: true,
                    onChanged: (val) => confirmPassword = val,
                    validator: (val) =>
                        val != password ? 'Passwords do not match' : null,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text("Register", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  if (registrationSuccess && registeredUser != null) ...[
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            responseMessage ?? '',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          Text('User ID: ${registeredUser!.id}',
                              style: TextStyle(color: Colors.white)),
                          Text(
                              'Name: ${registeredUser!.firstName} ${registeredUser!.lastName}',
                              style: TextStyle(color: Colors.white)),
                          Text('Phone: ${registeredUser!.phone}',
                              style: TextStyle(color: Colors.white)),
                          Text('Address: ${registeredUser!.address}',
                              style: TextStyle(color: Colors.white)),
                          Text('Email: ${registeredUser!.email}',
                              style: TextStyle(color: Colors.white)),
                          Text('Created at: ${registeredUser!.createdAt}',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Colors.white),
    filled: true,
    fillColor: Colors.white.withOpacity(0.2),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}

Widget _styledField(
  String label, {
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  required void Function(String) onChanged,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator:
          validator ?? (val) => val == null || val.isEmpty ? 'Required' : null,
    ),
  );
}
