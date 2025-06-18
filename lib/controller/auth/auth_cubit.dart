import 'package:e_commerceapp/controller/auth/auth_state.dart';
import 'package:e_commerceapp/data/auth/login.dart';
import 'package:e_commerceapp/data/auth/logout.dart';
import 'package:e_commerceapp/data/auth/register.dart';
import 'package:e_commerceapp/data/profile/profile.dart';
import 'package:e_commerceapp/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginService loginService;
  final RegisterService registerService;
  final LogoutService logoutService;
  final ProfileService profileService;
  AuthCubit({
    required this.logoutService,
    required this.loginService,
    required this.registerService,
    required this.profileService,
  }) : super(AuthState(status: AuthStatus.unauthenticated));

  void login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final loggedInUser =
          await loginService.login(email: email, password: password);
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        userModel: loggedInUser,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void register({required UserModel userData}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final registeredUser = await registerService.registerUser(userData);
      emit(state.copyWith(
        status: AuthStatus.registered,
        userModel: registeredUser,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void profile({required String token}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final profile = await profileService.getProfileDetails(token: token);
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        userModel: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // void logout({required String? token}) async {
  //   emit(state.copyWith(status: AuthStatus.loading));
  //   try {
  //     await logoutService.logout(token: token);
  //     emit(state.copyWith(status: AuthStatus.unauthenticated));
  //   } catch (e) {
  //     emit(state.copyWith(
  //       status: AuthStatus.error,
  //       errorMessage: e.toString(),
  //     ));
  //   }
  // }
}
