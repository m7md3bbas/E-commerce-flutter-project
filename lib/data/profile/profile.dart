import 'package:dio/dio.dart';
import 'package:e_commerceapp/models/user_model.dart';

class ProfileService {
  final Dio dio;
  ProfileService({required this.dio});

  Future<UserModel> getProfileDetails({required String token}) async {
    try {
      final Response response = await dio.get(
        'https://ib.jamalmoallart.com/api/v2/profile',
        data: {'token': token},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return UserModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to fetch profile details: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('Error fetching profile details: $e');
    }
  }
}
