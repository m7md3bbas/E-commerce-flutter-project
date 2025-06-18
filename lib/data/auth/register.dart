import 'package:dio/dio.dart';
import 'package:e_commerceapp/helpers/adaptor.dart';
import 'package:e_commerceapp/models/user_model.dart';

class RegisterService {
  final Dio dio;

  RegisterService({required this.dio});

  Future<UserModel> registerUser(UserModel userData) async {
    const String url = 'https://ib.jamalmoallart.com/api/v2/register';

    final fullname = NameAdaptor(fullName: userData.fullName);

    FormData formData = FormData.fromMap({
      'first_name': fullname.firstName,
      'last_name': fullname.lastName,
      'phone': userData.phoneNumber,
      'address': userData.address,
      'email': userData.email,
      'password': userData.password,
    });

    try {
      Response response = await dio.post(
        url,
        data: formData,
      );

      if (response.data['state'] == true) {
        final data = response.data['data'];
        return UserModel.fromJson(data);
      } else {
        String errorMessage = response.data['message'] ?? 'Registration failed';
        if (response.data['data'] is String) {
          errorMessage += ': ${response.data['data']}';
        }
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      if (e.response?.data != null) {
        String errorMessage =
            e.response?.data['message'] ?? 'Registration failed';
        if (e.response?.data['data'] is String) {
          errorMessage += ': ${e.response?.data['data']}';
        }
        throw Exception(errorMessage);
      }
      throw Exception('Network error during registration');
    } catch (e) {
      throw Exception('Error during registration: ${e.toString()}');
    }
  }
}
