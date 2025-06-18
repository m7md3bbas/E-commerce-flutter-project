import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerceapp/constant.dart';
import 'package:e_commerceapp/controller/cart/cart_cubit.dart';
import 'package:e_commerceapp/controller/order/order_cubit.dart';
import 'package:e_commerceapp/controller/order/order_state.dart';
import 'package:e_commerceapp/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

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
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state.status == OrderStatus.orderPlaced) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Order placed successfully!')));

          context.read<CartCubit>().clearCart();
        } else if (state.status == OrderStatus.error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to place order')));
        }
      },
      builder: (context, state) {
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
                'Your Order',
                style: TextStyle(
                    color: BaseColors.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
          body: state.status == OrderStatus.placingOrder
              ? Center(child: CircularProgressIndicator())
              : state.status == OrderStatus.orderPlaced
                  ? ListView(
                      padding: EdgeInsets.all(16),
                      children: [
                        ...state.orderItems.map((item) {
                          final localimage = getImagePath(item.product);
                          final islocalimage = localimage.startsWith("assets/");

                          return ListTile(
                            leading: islocalimage
                                ? Image.asset(
                                    localimage,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: item.product.image,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                            title: Text(
                              item.product.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: BaseColors.primary),
                            ),
                            subtitle: Text(
                              '${item.quantity} x EGP ${item.product.price}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: BaseColors.primary),
                            ),
                            trailing: Text(
                              'Done',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: BaseColors.primary),
                            ),
                          );
                        }),
                        Divider(),
                        Text(
                          'Total: EGP ${state.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: BaseColors.primary),
                        ),
                      ],
                    )
                  : Center(
                      child: ElevatedButton(
                        onPressed: () {
                          final cartCubit = context.read<CartCubit>();
                          context.read<OrderCubit>().placeOrder(
                              cartCubit.state.items,
                              cartCubit.state.totalPrice);
                        },
                        child: Text('Place Order'),
                      ),
                    ),
        );
      },
    );
  }
}
