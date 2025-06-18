import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerceapp/constant.dart';
import 'package:e_commerceapp/controller/cart/cart_cubit.dart';
import 'package:e_commerceapp/controller/cart/cart_state.dart';
import 'package:e_commerceapp/controller/order/order_cubit.dart';
import 'package:e_commerceapp/models/product_model.dart';
import 'package:e_commerceapp/screens/orders/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerceapp/models/cart_item_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String getImagePath({required ProductModel productModel}) {
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
    return Scaffold(
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.cartLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.cartError) {
            return Center(
                child: Text(
              'Failed to load cart.',
              style: TextStyle(
                  color: BaseColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ));
          } else if (state.items.isEmpty) {
            return Center(
                child: Text(
              'Your cart is empty.',
              style: TextStyle(
                  color: BaseColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final CartItem item = state.items[index];
                    final localimage = getImagePath(productModel: item.product);
                    final islocal = localimage.startsWith("assets/");
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: islocal
                            ? Image.asset(
                                localimage,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: item.product.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error, size: 50),
                              ),
                        title: Text(
                          item.product.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: BaseColors.primary),
                        ),
                        subtitle: Text(
                          'EGP ${item.product.price} x ${item.quantity}',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: BaseColors.primary),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: BaseColors.primary,
                              ),
                              onPressed: () {
                                final newQty = item.quantity - 1;
                                context.read<CartCubit>().updateQuantity(
                                      item.product,
                                      newQty,
                                    );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: BaseColors.primary,
                              ),
                              onPressed: () {
                                final newQty = item.quantity + 1;
                                context.read<CartCubit>().updateQuantity(
                                      item.product,
                                      newQty,
                                    );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: BaseColors.primary,
                              ),
                              onPressed: () {
                                context
                                    .read<CartCubit>()
                                    .removeFromCart(item.product);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total: EGP ${state.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: BaseColors.primary),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BaseColors.primary,
                      ),
                      onPressed: () {
                        final cartState = context.read<CartCubit>().state;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<CartCubit>(), // if needed
                              child: BlocProvider(
                                create: (_) => OrderCubit()
                                  ..placeOrder(
                                      cartState.items, cartState.totalPrice),
                                child: OrderPage(),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Place Order',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
