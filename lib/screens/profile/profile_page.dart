import 'dart:io';

import 'package:e_commerceapp/constant.dart';
import 'package:e_commerceapp/controller/auth/auth_cubit.dart';
import 'package:e_commerceapp/controller/auth/auth_state.dart';
import 'package:e_commerceapp/helpers/shared_prefs_helper.dart';
import 'package:e_commerceapp/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? profileImage;
  String? dateOfBirth;
  String? gender;

  @override
  void initState() {
    getProfileDetails();
    super.initState();
  }

  void getProfileDetails() async {
    final email = context.read<AuthCubit>().state.userModel?.email;
    if (email == null) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final profileImage = prefs.getString("profileImage");

    final sharedPrefsHelper = SharedPrefsHelper();
    final savedGender = await sharedPrefsHelper.getGender(gamil: email);
    final savedDateOfBirth =
        await sharedPrefsHelper.getDateOfBirth(gamil: email);

    setState(() {
      this.profileImage = profileImage;
      gender = savedGender;
      dateOfBirth = savedDateOfBirth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: profileImage != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(File(profileImage!)),
                            )
                          : const CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return Text(
                          state.userModel?.fullName != null
                              ? state.userModel!.fullName
                              : 'Loading...',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: BaseColors.primary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return Text(
                          state.userModel?.email != null
                              ? state.userModel!.email
                              : 'Loading...',
                          style: TextStyle(
                            fontSize: 18,
                            color: BaseColors.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return ListTile(
                            leading:
                                Icon(Icons.phone, color: BaseColors.primary),
                            title: Text(
                              'Phone',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: BaseColors.primary,
                              ),
                            ),
                            subtitle: Text(state.userModel?.phoneNumber != null
                                ? state.userModel!.phoneNumber
                                : 'Loading...'),
                          );
                        },
                      ),
                      const Divider(),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return ListTile(
                            leading: Icon(Icons.location_on,
                                color: BaseColors.primary),
                            title: Text(
                              'Address',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: BaseColors.primary,
                              ),
                            ),
                            subtitle: Text(state.userModel?.address != null
                                ? state.userModel!.address
                                : 'Loading...'),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.cake, color: BaseColors.primary),
                        title: Text(
                          'Date of Birth',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: BaseColors.primary,
                          ),
                        ),
                        subtitle: Text(
                          dateOfBirth != null
                              ? dateOfBirth!.split(" ")[0]
                              : 'Loading',
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.person_outline,
                            color: BaseColors.primary),
                        title: Text(
                          'Gender',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: BaseColors.primary,
                          ),
                        ),
                        subtitle: Text(
                          gender != null ? gender! : 'Loading',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: BaseColors.primary,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: BaseColors.primary),
                  ),
                  onTap: () async {
                    final sharedPrefsHelper = SharedPrefsHelper();
                    sharedPrefsHelper.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.login, (route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
