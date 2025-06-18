import 'package:e_commerceapp/constant.dart';
import 'package:e_commerceapp/controller/auth/auth_cubit.dart';
import 'package:e_commerceapp/controller/auth/auth_state.dart';
import 'package:e_commerceapp/controller/category/category_cubit.dart';
import 'package:e_commerceapp/controller/category/category_state.dart';
import 'package:e_commerceapp/controller/product/product_cubit.dart';
import 'package:e_commerceapp/controller/product/product_state.dart';
import 'package:e_commerceapp/helpers/shared_prefs_helper.dart';
import 'package:e_commerceapp/models/product_model.dart';
import 'package:e_commerceapp/screens/cart/cart_page.dart';
import 'package:e_commerceapp/screens/product/product_details_page.dart';
import 'package:e_commerceapp/screens/profile/profile_page.dart';
import 'package:e_commerceapp/screens/search/product_search_delegate.dart';
import 'package:e_commerceapp/widgets/category_item.dart';
import 'package:e_commerceapp/widgets/image_carusal.dart';
import 'package:e_commerceapp/widgets/product_card.dart';
import 'package:e_commerceapp/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 0;
  List<ProductModel> categoryProducts = [];

  List<ProductModel> getProductCategory({
    required String category,
    required List<ProductModel> products,
  }) {
    categoryProducts =
        products.where((product) => product.category == category).toList();
    return categoryProducts;
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  Future<void> _refreshProducts(BuildContext context) async {
    context.read<ProductCubit>().productService.getAllProducts();
    context.read<CategoryCubit>().categoryService.getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(context),
      CartPage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseColors.primary,
        title: Text(
          'Abbas Store',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(
                  products:
                      context.read<ProductCubit>().state.productModel ?? [],
                ),
              );
            },
          ),
        ],
      ),
      body: pages[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        onTap: _onItemTapped,
        selectedItemColor: BaseColors.primary,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget HomePage(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: state.userModel == null
                      ? Text('Welcome')
                      : Text(
                          'Welcome, ${state.userModel?.fullName}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: BaseColors.primary),
                        ),
                );
              },
            ),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state.productModel == null || state.productModel!.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return ImageCarousel(products: state.productModel!);
              },
            ),
            SectionTitle('Categories'),
            SizedBox(
              height: 100,
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  if (state.categories == null || state.categories!.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: state.categories!
                        .map((category) => CategoryItem(
                            products: getProductCategory(
                              category: category,
                              products: context
                                      .read<ProductCubit>()
                                      .state
                                      .productModel ??
                                  [],
                            ),
                            categoryName: category))
                        .toList(),
                  );
                },
              ),
            ),
            SectionTitle('Featured Products'),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state.productModel == null || state.productModel!.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: state.productModel!.length,
                  itemBuilder: (context, index) {
                    final product = state.productModel![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsPage(product: product),
                          ),
                        );
                      },
                      child: ProductCard(productModel: product),
                    );
                  },
                );
              },
            ),
            SectionTitle('New Arrivals'),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state.productModel == null || state.productModel!.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.productModel!.length,
                    itemBuilder: (context, index) {
                      final product = state.productModel![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailsPage(product: product),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ProductCard(productModel: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
