import 'package:e_commerceapp/models/cart_item_model.dart';
import 'package:flutter/foundation.dart';

enum CartStatus { cartLoaded, cartLoading, error }

extension CartStatusX on CartState {
  bool get cartLoaded => status == CartStatus.cartLoaded;
  bool get cartLoading => status == CartStatus.cartLoading;
  bool get cartError => status == CartStatus.error;
}

class CartState {
  final List<CartItem> items;
  final double totalPrice;
  final CartStatus status;

  CartState({
    required this.status,
    required this.items,
    required this.totalPrice,
  });

  factory CartState.initial() {
    return CartState(
      items: [],
      totalPrice: 0.0,
      status: CartStatus.cartLoading,
    );
  }
  CartState copyWith({
    CartStatus? status,
    List<CartItem>? items,
    double? totalPrice,
  }) =>
      CartState(
        status: status ?? this.status,
        items: items ?? this.items,
        totalPrice: totalPrice ?? this.totalPrice,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          items == other.items &&
          totalPrice == other.totalPrice;

  @override
  String toString() {
    return 'CartState(items: $items, totalPrice: $totalPrice , status: $status) ';
  }
}
