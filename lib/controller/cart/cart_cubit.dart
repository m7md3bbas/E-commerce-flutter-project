import 'package:bloc/bloc.dart';
import 'package:e_commerceapp/models/cart_item_model.dart';
import 'package:e_commerceapp/models/product_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial());

  void loadCart() {
    emit(state.copyWith(status: CartStatus.cartLoading));
    Future.delayed(Duration(milliseconds: 300), () {
      emit(state.copyWith(
        status: CartStatus.cartLoaded,
        items: [],
        totalPrice: 0.0,
      ));
    });
  }

  void addToCart(ProductModel product, int quantity) {
    final existingIndex =
        state.items.indexWhere((item) => item.product.id == product.id);
    List<CartItem> updatedItems = List.from(state.items);

    if (existingIndex != -1) {
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(quantity: quantity);
    } else {
      updatedItems.add(CartItem(product: product, quantity: quantity));
    }

    emit(state.copyWith(
      items: updatedItems,
      status: CartStatus.cartLoaded,
      totalPrice: _calculateTotalPrice(updatedItems),
    ));
  }

  void removeFromCart(ProductModel product) {
    final updatedItems =
        state.items.where((item) => item.product.id != product.id).toList();

    emit(state.copyWith(
      items: updatedItems,
      totalPrice: _calculateTotalPrice(updatedItems),
    ));
  }

  void updateQuantity(ProductModel product, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(product);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.product.id == product.id) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    emit(state.copyWith(
      items: updatedItems,
      totalPrice: _calculateTotalPrice(updatedItems),
    ));
  }

  double _calculateTotalPrice(List<CartItem> items) {
    return items.fold(
      0.0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  void clearCart() {
    emit(state.copyWith(items: [], totalPrice: 0.0));
  }
}
