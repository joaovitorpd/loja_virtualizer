import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtualizer/datas/cart_product.dart';
import 'package:loja_virtualizer/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel? user;

  List<CartProduct> products = [];

  String? couponCode = "";
  int discountPercentage = 0;

  String shipPrice = "0.00";
  String shippinDeadline = "0";

  bool isLoading = false;

  CartModel(this.user){
    if(user!.isLoggedIn()){
      _loadCartItems();
    }
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);

    FirebaseFirestore.instance.collection("users").doc(user?.firebaseUser?.uid)
    .collection("cart").add(cartProduct.toMap()).then((cartId) {
      cartProduct.cid = cartId.id;
    });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    FirebaseFirestore.instance.collection("users").doc(user?.firebaseUser?.uid)
        .collection("cart").doc(cartProduct.cid).delete();
    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;

    FirebaseFirestore.instance.collection("users").doc(user!.firebaseUser!.uid)
    .collection("cart").doc(cartProduct.cid).update(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;

    FirebaseFirestore.instance.collection("users").doc(user!.firebaseUser!.uid)
        .collection("cart").doc(cartProduct.cid).update(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices(){
    notifyListeners();
  }

  double getProductsPrice() {
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null){
        price += c.quantity * c.productData!.price;
      }
    }
    return price;
  }

  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  void setShipPrice(String shipPrice){
    this.shipPrice = shipPrice;

  }

  void setShippingDeadline(String shippinDeadline){
    this.shippinDeadline = shippinDeadline;

  }

  double getShipPrice() {
    var ship = double.parse(shipPrice.replaceAll(",", "."));
    assert(ship is double);
    return ship;

  }

  Future<String> finishOrder() async{
    //if(products.length == 0) return null;
    
    isLoading = true;
    notifyListeners();
    
    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    //Cria e salva "order" no Firebase
    DocumentReference refOrder = await FirebaseFirestore.instance.collection("orders").add(
        {
          "clientId": user!.firebaseUser!.uid,
          "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
          "shipPrice": shipPrice,
          "productsPrice": productsPrice,
          "discount": discount,
          "totalPrice": productsPrice + shipPrice - discount,
          "status": 1
    });
    //Salva a referência do pedido no usuário
    await FirebaseFirestore.instance.collection("users").doc(user!.firebaseUser!.uid)
    .collection("orders").doc(refOrder.id).set(
        {
          "orderId": refOrder.id
        });
    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user!.firebaseUser!.uid)
    .collection("cart").get();

    for(DocumentSnapshot doc in query.docs){
      doc.reference.delete();
    }
    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.id;

  }

  void _loadCartItems() async {

    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user!.firebaseUser!.uid)
        .collection("cart").get();

    //Transformando cada documento que o Firebase retornou em uma lista de CartProduct
    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

}