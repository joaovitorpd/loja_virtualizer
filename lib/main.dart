import 'package:flutter/material.dart';
import 'package:loja_virtualizer/models/cart_model.dart';
import 'package:loja_virtualizer/models/user_model.dart';
import 'package:loja_virtualizer/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loja_virtualizer/screens/login_screen.dart';
import 'package:loja_virtualizer/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
        child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            return ScopedModel<CartModel>(
              model: CartModel(model),
              child: MaterialApp(
                title: 'Loja Virtualizer',
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    primaryColor: Color.fromARGB(255, 4, 125, 141)
                ),
                debugShowCheckedModeBanner: false,
                home: HomeScreen(),
              ),
            );
          },
        ),
    );
  }
}