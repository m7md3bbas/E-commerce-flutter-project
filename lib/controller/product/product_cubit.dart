import 'package:e_commerceapp/controller/product/product_state.dart';
import 'package:e_commerceapp/data/home/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService productService;
  ProductCubit({required this.productService}) : super(ProductState());

  Future<void> getProduct() async {
    emit(state.copyWith(status: ProductStatus.productLoading));
    try {
      final products = await productService.getAllProducts();
      emit(state.copyWith(
          status: ProductStatus.productLoaded, productModel: products));
    } catch (e) {
      emit(state.copyWith(
          status: ProductStatus.error, errorMessage: e.toString()));
    }
  }
}
