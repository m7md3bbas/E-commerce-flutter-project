import 'package:e_commerceapp/bloc_observer.dart';
import 'package:e_commerceapp/controller/auth/auth_cubit.dart';
import 'package:e_commerceapp/controller/cart/cart_cubit.dart';
import 'package:e_commerceapp/controller/category/category_cubit.dart';
import 'package:e_commerceapp/controller/product/product_cubit.dart';
import 'package:e_commerceapp/helpers/locator.dart';
import 'package:e_commerceapp/routes/app_routes.dart';
import 'package:e_commerceapp/screens/auth/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setupServiceLocator();

  Bloc.observer = MyBlocObserver();
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<CartCubit>()..loadCart()),
        BlocProvider(
            create: (context) => locator<ProductCubit>()..getProduct()),
        BlocProvider(
            create: (context) => locator<CategoryCubit>()..getcategory()),
        BlocProvider(create: (context) => locator<AuthCubit>())
      ],
      child: const MaterialApp(
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
        home: Splashscreen(),
      ),
    );
  }
}
