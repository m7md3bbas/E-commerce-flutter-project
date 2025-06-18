import 'package:dio/dio.dart';
import 'package:e_commerceapp/controller/auth/auth_cubit.dart';
import 'package:e_commerceapp/controller/cart/cart_cubit.dart';
import 'package:e_commerceapp/controller/category/category_cubit.dart';
import 'package:e_commerceapp/controller/order/order_cubit.dart';
import 'package:e_commerceapp/controller/product/product_cubit.dart';
import 'package:e_commerceapp/data/auth/login.dart';
import 'package:e_commerceapp/data/auth/logout.dart';
import 'package:e_commerceapp/data/auth/register.dart';
import 'package:e_commerceapp/data/home/category.dart';
import 'package:e_commerceapp/data/home/product.dart';
import 'package:e_commerceapp/data/profile/profile.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupServiceLocator() {
  locator.registerFactory<Dio>(() => Dio());
  locator.registerFactory<LoginService>(() => LoginService(dio: Dio()));
  locator.registerFactory<RegisterService>(() => RegisterService(dio: Dio()));
  locator.registerFactory<ProductService>(() => ProductService(dio: Dio()));
  locator.registerFactory<CategoryService>(() => CategoryService(dio: Dio()));
  locator.registerFactory<LogoutService>(() => LogoutService(dio: Dio()));
  locator.registerFactory<ProfileService>(() => ProfileService(dio: Dio()));

  locator.registerLazySingleton<OrderCubit>(() => OrderCubit());
  locator.registerLazySingleton<CartCubit>(() => CartCubit());
  locator.registerLazySingleton<CategoryCubit>(
      () => CategoryCubit(categoryService: locator<CategoryService>()));
  locator.registerLazySingleton(
      () => ProductCubit(productService: locator<ProductService>()));
  locator.registerLazySingleton<AuthCubit>(() => AuthCubit(
      profileService: locator<ProfileService>(),
      logoutService: locator<LogoutService>(),
      loginService: locator<LoginService>(),
      registerService: locator<RegisterService>()));
}
