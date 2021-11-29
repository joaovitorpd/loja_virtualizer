import 'package:flutter/material.dart';
import 'package:loja_virtualizer/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {

  final VoidCallback buy;

  CartPrice(this.buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CartModel>(
          builder: (context, child, model) {
            double price = model.getProductsPrice();
            double discount = model.getDiscount();
            double shipPrice = model.getShipPrice();


            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Resumo do Pedido",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subtotal"),
                    Text("R\$ ${price.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Desconto"),
                    Text(discount == 0.00 ? "R\$ 0.00" : "R\$ -${discount.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Entrega"),
                    Text("R\$ ${shipPrice.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(),
                SizedBox(height: 12.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total",
                    style: TextStyle(fontWeight: FontWeight.w500),),
                    Text("R\$ ${(price + shipPrice - discount).toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.0),),
                  ],
                ),
                SizedBox(height: 12.0,),
                ElevatedButton(
                  child: Text("Finalizar Pedido", style: TextStyle(fontSize: 18.0),),
                  style: ElevatedButton.
                  styleFrom(primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(color: Colors.white)),
                  onPressed: buy,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
