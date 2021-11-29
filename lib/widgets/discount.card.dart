import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtualizer/models/cart_model.dart';

class DiscountCard extends StatelessWidget {
  const DiscountCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _timeForMessage = 3;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Cupom de Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.card_giftcard, color: Colors.grey[500],),
        trailing: Icon(Icons.add, color: Colors.grey[500],),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom"
              ),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance.collection("coupons").doc(text).get().then(
                    (docSnap) {
                      if(docSnap.data() != null){
                        CartModel.of(context).setCoupon(text, docSnap["percent"]);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Desconto de ${docSnap["percent"]}% aplicado!"),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: Duration(seconds: _timeForMessage),
                            )
                        );
                      }else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Cupom não existente!"),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: _timeForMessage),
                          )
                        );
                      }
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
