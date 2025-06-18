import 'dart:io';

import 'package:e_commerceapp/constant.dart';
import 'package:e_commerceapp/controller/auth/auth_cubit.dart';
import 'package:e_commerceapp/controller/auth/auth_state.dart';
import 'package:e_commerceapp/helpers/shared_prefs_helper.dart';
import 'package:e_commerceapp/models/user_model.dart';
import 'package:e_commerceapp/routes/app_routes.dart';
import 'package:e_commerceapp/widgets/customtextformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _addressController;
  final SharedPrefsHelper _sharedPrefsHelper = SharedPrefsHelper();
  DateTime? _dateOfBirth;
  String? _gender;

  final SharedPrefsHelper sharedPrefsHelper = SharedPrefsHelper();
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _addressController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _register() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _fullNameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    final registeruser = UserModel(
      createdAt: DateTime.now().toIso8601String(),
      password: password,
      fullName: name,
      email: email,
      phoneNumber: phone,
      address: address,
    );
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(userData: registeruser);
    }
  }

  String? nameValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (!RegExp(r'^[a-zA-Z]+ [a-zA-Z]+$').hasMatch(value)) {
      return 'Please enter a valid full name with a space between first and last name';
    }
    return null;
  }

  String? emailValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? passwordValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? confirmPasswordValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? phoneValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone ';
    }
    if (value.length > 11 || value.length < 11) {
      return 'Phone must be 11 digits';
    }

    return null;
  }

  String? addressValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }

    return null;
  }

  String? genderValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please select your gender';
    }
    return null;
  }

  String? dateOfBirthValidator(value) {
    if (value == null) {
      return 'Please select your date of birth';
    }
    return null;
  }

  String? profileImageValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Please select your profile image';
    }
    return null;
  }

  File? _avatar;

  void saveProfileImage(String path, {required String gamil}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("profileImage$gamil", path);
  }

  void pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      saveProfileImage(pickedFile.path, gamil: _emailController.text.trim());
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                SizedBox(height: 56),
                Text('Register',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: BaseColors.primary)),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black,
                        backgroundImage:
                            _avatar != null ? FileImage(_avatar!) : null,
                        child: _avatar == null
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: CircleAvatar(
                          backgroundColor: BaseColors.primary,
                          radius: 18,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 18,
                            onPressed: pickImage,
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomTextformfield(
                  emailController: _fullNameController,
                  validator: nameValidator,
                  obsecureText: false,
                  labelText: 'Full Name',
                  keyboardType: TextInputType.name,
                ),
                CustomTextformfield(
                  emailController: _emailController,
                  validator: emailValidator,
                  obsecureText: false,
                  labelText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextformfield(
                        emailController: _passwordController,
                        validator: passwordValidator,
                        obsecureText: true,
                        labelText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextformfield(
                        emailController: _confirmPasswordController,
                        validator: confirmPasswordValidator,
                        obsecureText: true,
                        labelText: 'Confirm Password',
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextformfield(
                        emailController: _phoneController,
                        validator: phoneValidator,
                        obsecureText: false,
                        labelText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextformfield(
                        emailController: _addressController,
                        validator: addressValidator,
                        obsecureText: false,
                        labelText: 'Address',
                        keyboardType: TextInputType.streetAddress,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _gender,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                  color: BaseColors.primary,
                                )),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(color: BaseColors.primary),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(color: BaseColors.primary),
                            ),
                            labelText: 'Gender',
                            labelStyle: TextStyle(color: BaseColors.primary)),
                        items: [
                          DropdownMenuItem(
                              value: 'Male',
                              child: Text(
                                'Male',
                                style: TextStyle(color: BaseColors.primary),
                              )),
                          DropdownMenuItem(
                              value: 'Female',
                              child: Text(
                                'Female',
                                style: TextStyle(color: BaseColors.primary),
                              )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your gender';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: BaseColors.primary,
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () async {
                              final selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                setState(() {
                                  _dateOfBirth = selectedDate;
                                });
                              }
                            },
                            child: Text(
                              _dateOfBirth == null
                                  ? 'Select Date'
                                  : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                              style: TextStyle(color: BaseColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state.status == AuthStatus.registered) {
                        print(_dateOfBirth.toString());
                        print(_gender.toString());
                        _sharedPrefsHelper.saveDateOfBirth(
                          dateOfBirth: _dateOfBirth.toString(),
                          gamil: _emailController.text.trim(),
                        );
                        if (_avatar != null) {
                          saveProfileImage(_avatar!.path,
                              gamil: _emailController.text.trim());
                        }
                        _sharedPrefsHelper.saveGender(
                          gender: _gender!,
                          gamil: _emailController.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registration successful'),
                          ),
                        );
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.login);
                      }
                      if (state.status == AuthStatus.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registration failed'),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BaseColors.primary,
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: _register,
                        child: state.status == AuthStatus.loading
                            ? CircularProgressIndicator()
                            : Text(
                                'register',
                                style: TextStyle(color: Colors.white),
                              ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: BaseColors.primary)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                      child: Text(
                        'Login here',
                        style: TextStyle(
                            color: BaseColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: BaseColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
