import 'package:dio/dio.dart';

class LogoutService {
  final Dio dio;
  LogoutService({required this.dio});
  Future<void> logout({required String token}) async {
    const String url = 'https://ib.jamalmoallart.com/api/v2/logout';
    try {
      Response response = await dio.post(
        url,
        data: {'token': token},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['state'] == true) {
      } else {
        throw Exception('Logout failed: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('Error during logout: $e');
    }
  }
}
