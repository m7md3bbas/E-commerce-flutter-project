import 'package:e_commerceapp/controller/category/category_state.dart';
import 'package:e_commerceapp/data/home/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryService categoryService;
  CategoryCubit({required this.categoryService}) : super(CategoryState());

  Future<void> getcategory() async {
    emit(state.copyWith(status: CategoryStatus.categoryLoading));
    try {
      final List<String> category = await categoryService.getAllCategories();
      print("${category.length} from category cubit");
      emit(state.copyWith(
          status: CategoryStatus.categoryLoaded, categories: category));
    } catch (e) {
      print("Error from category cubit");
      emit(state.copyWith(
          status: CategoryStatus.error, errorMessage: e.toString()));
    }
  }
}
