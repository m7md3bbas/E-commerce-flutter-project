import 'package:e_commerceapp/constant.dart';
import 'package:e_commerceapp/models/product_model.dart';
import 'package:e_commerceapp/screens/product/product_details_page.dart';
import 'package:e_commerceapp/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryProductsPage extends StatelessWidget {
  final String categoryName;
  final List<ProductModel> products;
  const CategoryProductsPage({
    super.key,
    required this.categoryName,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products
        .where((product) => product.category == categoryName)
        .take(8)
        .toList();

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: BaseColors.primary,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            categoryName,
            style: TextStyle(
                color: BaseColors.primary,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          )),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: filteredProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsPage(product: product),
                  ),
                );
              },
              child: ProductCard(
                productModel: product,
              ),
            );
          },
        ),
      ),
    );
  }
}
