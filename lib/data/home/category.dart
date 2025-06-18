import 'package:dio/dio.dart';

class CategoryService {
  final String _baseUrl = "https://ib.jamalmoallart.com/api/v1/all/categories";
  final Dio dio;

  CategoryService({required this.dio});

  Future<List<String>> getAllCategories() async {
    try {
      final Response response = await dio.get(_baseUrl);

      if (response.statusCode == 200) {
        final List<String> data =
            (response.data as List<dynamic>).cast<String>();
        return data;
      } else {
        throw Exception(
          'Failed to fetch categories: ${response.data['message']}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}
