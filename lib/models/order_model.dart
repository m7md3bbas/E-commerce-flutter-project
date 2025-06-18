import 'package:e_commerceapp/models/cart_item_model.dart';

class OrderModel {
  final List<CartItem> items;
  final double totalPrice;
  final DateTime orderDate;

  OrderModel(
      {required this.items, required this.totalPrice, required this.orderDate});
}
