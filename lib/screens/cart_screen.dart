import 'package:flutter/material.dart';
import 'package:loja_virtualizer/models/cart_model.dart';
import 'package:loja_virtualizer/models/user_model.dart';
import 'package:loja_virtualizer/tiles/cart_tile.dart';
import 'package:loja_virtualizer/widgets/cart_price.dart';
import 'package:loja_virtualizer/widgets/discount.card.dart';
import 'package:loja_virtualizer/widgets/ship_card.dart';
import 'package:scoped_model/scoped_model.dart';
import 'login_screen.dart';
import 'order_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Meu Carrinho"),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 8.0),
            alignment: Alignment.center,
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int selectedProducts = 0;
                selectedProducts = model.products.length;

                return Text(
                  "${selectedProducts} ${selectedProducts == 1 ? "ITEM" : "ITEMS"}",
                  style: TextStyle(fontSize: 17.0),
                );
              },
            ),
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(!UserModel.of(context).isLoggedIn()){
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart,
                    size: 80.0, color: Theme.of(context).primaryColor,),
                  SizedBox(height: 16.0,),
                  Text("Faça o login para adicionar produtos!",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0,),
                  ElevatedButton(
                    child: Text("Entrar", style: TextStyle(fontSize: 18.0),),
                    style: ElevatedButton.
                    styleFrom(primary: Theme.of(context).primaryColor,
                        textStyle: TextStyle(color: Colors.white)),
                    onPressed: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=>LoginScreen())
                      );
                    },
                  ),
                ],
              ),
            );
          }else if (model.products == null || model.products.length == 0){
            return Center(
              child: Text("Nenhum produto no carrinho!",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            );
          } else {
            return ListView(
              children: [
                Column(
                  children: model.products.map(
                          (product){
                        return CartTile(product);
                      }
                  ).toList(),
                ),
                DiscountCard(),
                ShipCard(),
                CartPrice(() async{
                  String orderId = await model.finishOrder();
                  if(orderId != null){
                    //print(orderId);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context)=>OrderScreen(orderId))
                    );
                  }
                }),
              ],
            );
          }
        },
      ),
    );
  }
}



