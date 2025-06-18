import 'package:e_commerceapp/controller/order/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item_model.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderState.initial());

  void placeOrder(List<CartItem> cartItems, double total) async {
    emit(state.copyWith(status: OrderStatus.placingOrder));

    try {
      await Future.delayed(Duration(seconds: 2));

      emit(state.copyWith(
        status: OrderStatus.orderPlaced,
        orderItems: cartItems,
        totalPrice: total,
      ));
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.error));
    }
  }

  void resetOrder() {
    emit(OrderState.initial());
  }
}
