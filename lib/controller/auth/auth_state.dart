import 'package:e_commerceapp/models/user_model.dart';

enum AuthStatus { authenticated, registered, unauthenticated, loading, error }

extension AuthStatusX on AuthState {
  bool get loaded => status == AuthStatus.loading;
  bool get unauthenticated => status == AuthStatus.unauthenticated;
  bool get registered => status == AuthStatus.registered;
  bool get authenticated => status == AuthStatus.authenticated;
  bool get error => status == AuthStatus.error;
}

class AuthState {
  final String? errorMessage;
  final AuthStatus status;
  final UserModel? userModel;

  AuthState({
    this.errorMessage,
    this.status = AuthStatus.unauthenticated,
    this.userModel,
  });

  AuthState copyWith({
    String? errorMessage,
    AuthStatus? status,
    UserModel? userModel,
  }) =>
      AuthState(
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
        userModel: userModel ?? this.userModel,
      );

  @override
  String toString() =>
      'AuthState(status: $status, userModel: $userModel , error: $errorMessage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.errorMessage == errorMessage &&
        other.status == status &&
        other.userModel == userModel;
  }

  @override
  int get hashCode =>
      status.hashCode ^ userModel.hashCode ^ errorMessage.hashCode;
}
