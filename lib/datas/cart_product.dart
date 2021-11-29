import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtualizer/datas/product_data.dart';

class CartProduct {
  String cid = "";
  String category = "";

  String pid = "";

  int quantity = 0;

  String size = "";

  ProductData? productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.id;
    category = document["category"];
    pid = document["pid"];
    quantity = document["quantity"];
    size = document["size"];
  }

  Map<String, dynamic> toMap() {
    return{
      "category": category,
      "pid": pid,
      "quantity": quantity,
      "size": size,
      "product": productData!.toResumedMap()
    };
  }
}