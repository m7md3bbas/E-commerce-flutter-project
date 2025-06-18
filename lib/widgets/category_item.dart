import 'package:e_commerceapp/constant.dart';
import 'package:e_commerceapp/models/product_model.dart';
import 'package:e_commerceapp/screens/category/category_products_page.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String categoryName;
  final List<ProductModel> products;
  const CategoryItem(
      {super.key, required this.products, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryProductsPage(
              products: products, categoryName: categoryName),
        ),
      ),
      child: Container(
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: BaseColors.primary,
        ),
        child: Center(
          child: Text(
            categoryName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
