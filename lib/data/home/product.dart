import 'package:dio/dio.dart';
import 'package:e_commerceapp/models/product_model.dart';

class ProductService {
  final Dio dio;

  ProductService({required this.dio});
  final String _baseUrl = 'https://ib.jamalmoallart.com/api/v1/all/products';
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final Response response = await dio.get(_baseUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch products: ${response.data['message']}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
