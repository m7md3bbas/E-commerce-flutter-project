import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerceapp/constant.dart';
import 'package:e_commerceapp/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel productModel;

  const ProductCard({super.key, required this.productModel});

  String getImagePath() {
    if (productModel.name == "Laptop Pro") {
      return "assets/laptop_pro.jpg";
    }
    if (productModel.name == "Smartphone Ultra") {
      return "assets/smartphoneultra.jpg";
    }
    if (productModel.name == "Bluetooth Speaker") {
      return "assets/bluetoothspeaker.jpg";
    }
    if (productModel.name == "DSLR Camera") {
      return "assets/dslrcamera.jpg";
    }
    if (productModel.name == "External Hard Drive") {
      return "assets/externalharddrive.jpg";
    }
    return productModel.image;
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = getImagePath();

    final isLocalImage = imagePath.startsWith("assets/");

    return Card(
      elevation: 4,
      color: BaseColors.primary,
      child: Column(
        children: [
          Expanded(
            child: isLocalImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      width: 200,
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  )
                : CachedNetworkImage(
                    width: 200,
                    imageUrl: imagePath,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  productModel.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('EGP ${productModel.price.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
