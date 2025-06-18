import 'package:dio/dio.dart';
import 'package:e_commerceapp/models/user_model.dart';

class LoginService {
  final Dio dio;
  static const String _baseUrl = 'https://ib.jamalmoallart.com/api/v2/login';

  LoginService({required this.dio});

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        _baseUrl,
        data: {
          'email': email.trim(),
          'password': password.trim(),
        },
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      final responseData = response.data;

      if (responseData['state'] == true) {
        return UserModel.fromJson(responseData['data']);
      }
      throw _handleError(responseData);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Exception _handleError(Map<String, dynamic> responseData) {
    final message = responseData['message'] ?? 'Login failed';
    final data = responseData['data'];

    if (data is String) {
      return Exception('$message: $data');
    }
    return Exception(message);
  }

  Exception _handleDioError(DioException e) {
    if (e.response?.data != null) {
      return _handleError(e.response!.data);
    }
    return Exception('Network error: ${e.message}');
  }
}
