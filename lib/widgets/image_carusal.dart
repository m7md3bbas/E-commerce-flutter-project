import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerceapp/models/product_model.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  final List<ProductModel> products;

  const ImageCarousel({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((item) => item.price >= 900).toList();

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: filtered.map((item) {
        String getImagePath() {
          if (item.name == "Laptop Pro") {
            return "assets/laptop_pro.jpg";
          }
          if (item.name == "Smartphone Ultra") {
            return "assets/smartphoneultra.jpg";
          }
          if (item.name == "Bluetooth Speaker") {
            return "assets/bluetoothspeaker.jpg";
          }
          if (item.name == "DSLR Camera") {
            return "assets/dslrcamera.jpg";
          }
          if (item.name == "External Hard Drive") {
            return "assets/externalharddrive.jpg";
          }
          return item.image;
        }

        final localImage = getImagePath();
        final islocalimage = localImage.startsWith("assets/");
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: islocalimage
                ? Image.asset(localImage, fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: item.image,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
          ),
        );
      }).toList(),
    );
  }
}
