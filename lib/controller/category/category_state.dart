enum CategoryStatus { categoryLoaded, categoryLoading, error }

extension CategoryStatusX on CategoryState {
  bool get categoryLoaded => status == CategoryStatus.categoryLoaded;
  bool get categoryLoading => status == CategoryStatus.categoryLoading;
  bool get categoryError => status == CategoryStatus.error;
}

class CategoryState {
  final String? errorMessage;
  final CategoryStatus status;
  final List<String>? categories;

  CategoryState({
    this.errorMessage,
    this.status = CategoryStatus.categoryLoading,
    this.categories,
  });

  CategoryState copyWith({
    String? errorMessage,
    CategoryStatus? status,
    List<String>? categories,
  }) =>
      CategoryState(
        errorMessage: errorMessage ?? this.errorMessage,
        status: status ?? this.status,
        categories: categories ?? this.categories,
      );

  @override
  String toString() =>
      'CategoryState(status: $status, ProductModel: $categories , error: $errorMessage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryState &&
        other.errorMessage == errorMessage &&
        other.status == status &&
        other.categories == categories;
  }

  @override
  int get hashCode =>
      status.hashCode ^ categories.hashCode ^ errorMessage.hashCode;
}
