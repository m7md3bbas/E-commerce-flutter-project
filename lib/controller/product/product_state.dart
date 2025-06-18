import 'package:e_commerceapp/models/product_model.dart';

enum ProductStatus { productLoaded, productLoading, error }

extension ProductStatusX on ProductState {
  bool get productLoaded => status == ProductStatus.productLoaded;
  bool get productLoading => status == ProductStatus.productLoading;
  bool get productError => status == ProductStatus.error;
}

class ProductState {
  final String? errorMessage;
  final ProductStatus status;
  final List<ProductModel>? productModel;

  ProductState({
    this.errorMessage,
    this.status = ProductStatus.productLoading,
    this.productModel,
  });

  ProductState copyWith({
    String? errorMessage,
    ProductStatus? status,
    List<ProductModel>? productModel,
  }) =>
      ProductState(
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
        productModel: productModel ?? this.productModel,
      );

  @override
  String toString() =>
      'ProductState(status: $status, ProductModel: $productModel , error: $errorMessage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductState &&
        other.errorMessage == errorMessage &&
        other.status == status &&
        other.productModel == productModel;
  }

  @override
  int get hashCode =>
      status.hashCode ^ productModel.hashCode ^ errorMessage.hashCode;
}
