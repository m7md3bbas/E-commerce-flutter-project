import '../../models/cart_item_model.dart';

enum OrderStatus { initial, placingOrder, orderPlaced, error }

extension OrderStateExtension on OrderState {
  bool get isOrderPlaced => status == OrderStatus.orderPlaced;
  bool get isPlacingOrder => status == OrderStatus.placingOrder;
  bool get hasError => status == OrderStatus.error;
}

class OrderState {
  final OrderStatus status;
  final List<CartItem> orderItems;
  final double totalPrice;

  OrderState({
    required this.status,
    required this.orderItems,
    required this.totalPrice,
  });

  factory OrderState.initial() => OrderState(
        status: OrderStatus.initial,
        orderItems: [],
        totalPrice: 0.0,
      );

  OrderState copyWith({
    OrderStatus? status,
    List<CartItem>? orderItems,
    double? totalPrice,
  }) {
    return OrderState(
      status: status ?? this.status,
      orderItems: orderItems ?? this.orderItems,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
