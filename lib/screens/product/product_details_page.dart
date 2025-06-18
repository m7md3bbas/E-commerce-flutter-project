import 'package:e_commerceapp/constant.dart';
import 'package:e_commerceapp/controller/cart/cart_cubit.dart';
import 'package:e_commerceapp/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

  void increment() {
    setState(() => quantity++);
  }

  void decrement() {
    if (quantity > 1) {
      setState(() => quantity--);
    }
  }

  String getImagePath() {
    if (widget.product.name == "Laptop Pro") {
      return "assets/laptop_pro.jpg";
    }
    if (widget.product.name == "Smartphone Ultra") {
      return "assets/smartphoneultra.jpg";
    }
    if (widget.product.name == "Bluetooth Speaker") {
      return "assets/bluetoothspeaker.jpg";
    }
    if (widget.product.name == "DSLR Camera") {
      return "assets/dslrcamera.jpg";
    }
    if (widget.product.name == "External Hard Drive") {
      return "assets/externalharddrive.jpg";
    }
    return widget.product.image;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final getimage = getImagePath();
    final isLocalImage = getimage.startsWith("assets/");
    return Scaffold(
      appBar: AppBar(
          backgroundColor: BaseColors.primary,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            product.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLocalImage
                ? Image.asset(getimage, height: 300, fit: BoxFit.fill)
                : CachedNetworkImage(
                    imageUrl: product.image,
                    height: 250,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) => Icon(Icons.error),
                  ),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: BaseColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              product.description ?? 'No description available.',
              style: TextStyle(
                  fontSize: 16,
                  color: BaseColors.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Text("Total Price: ",
                  style: TextStyle(
                      fontSize: 24,
                      color: BaseColors.primary,
                      fontWeight: FontWeight.bold)),
              Text(
                'EGP ${(product.price * quantity).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24, color: BaseColors.primary),
              ),
            ]),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Quantity',
                    style: TextStyle(
                        fontSize: 30,
                        color: BaseColors.primary,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: BaseColors.primary),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: BaseColors.primary,
                        ),
                        onPressed: decrement,
                      ),
                      Text('$quantity',
                          style: TextStyle(
                              fontSize: 16, color: BaseColors.primary)),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: BaseColors.primary,
                        ),
                        onPressed: increment,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BaseColors.primary,
                  fixedSize: const Size(250, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () {
                  context.read<CartCubit>().addToCart(widget.product, quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text('Added to cart')),
                  );
                },
                child: Text(
                  'Add to Cart',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
