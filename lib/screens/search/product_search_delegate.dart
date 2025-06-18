import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerceapp/constant.dart';
import 'package:e_commerceapp/models/product_model.dart';
import 'package:e_commerceapp/screens/product/product_details_page.dart';
import 'package:flutter/material.dart';

class ProductSearchDelegate extends SearchDelegate {
  final List<ProductModel> products;

  ProductSearchDelegate({required this.products});

  @override
  String? get searchFieldLabel => 'Search products';

  String getImagePath(ProductModel product) {
    if (product.name == "Laptop Pro") {
      return "assets/laptop_pro.jpg";
    }
    if (product.name == "Smartphone Ultra") {
      return "assets/smartphoneultra.jpg";
    }
    if (product.name == "Bluetooth Speaker") {
      return "assets/bluetoothspeaker.jpg";
    }
    if (product.name == "DSLR Camera") {
      return "assets/dslrcamera.jpg";
    }
    if (product.name == "External Hard Drive") {
      return "assets/externalharddrive.jpg";
    }
    return product.image;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(
            Icons.clear,
            color: BaseColors.primary,
          ),
          onPressed: () {
            query = '';
          },
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: BaseColors.primary,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(child: Text('No products found.'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) {
        final product = results[index];
        final localImage = getImagePath(product);
        final isLocal = localImage.startsWith("assets/");

        return ListTile(
          leading: isLocal
              ? Image.asset(
                  localImage,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl: product.image,
                  width: 50,
                  height: 50,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
          title:
              Text(product.name, style: TextStyle(color: BaseColors.primary)),
          subtitle: Text('EGP ${product.price}',
              style: TextStyle(fontSize: 16, color: BaseColors.primary)),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsPage(product: product),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        final localImage = getImagePath(product);
        final isLocal = localImage.startsWith("assets/");

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Card(
            elevation: 4,
            child: ListTile(
              leading: isLocal
                  ? Image.asset(
                      localImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: product.image,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
              title: Text(product.name),
              subtitle: Text('EGP ${product.price}'),
              onTap: () {
                query = product.name;
                showResults(context);
              },
            ),
          ),
        );
      },
    );
  }
}
