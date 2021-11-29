import 'package:flutter/material.dart';
import 'package:loja_virtualizer/models/user_model.dart';
import 'package:loja_virtualizer/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  int _timeForMessage = 3;

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        key: _scaffoldMessengerKey,
        backgroundColor: primaryColor,
        title: Text("Entrar"),
        centerTitle: true,
        actions: [
          TextButton(
            child: Text(
              "CRIAR CONTA",
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignUpScreen())
              );
            },
          ),
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading) {
            return Center(child: CircularProgressIndicator(),);
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text){
                    if(text!.isEmpty || !text.contains("@")){
                      return "Email inválido!";
                    }
                  },
                ),
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _passController,
                  decoration: InputDecoration(
                    hintText: "Senha",
                  ),
                  obscureText: true,
                  validator: (text) {
                    if(text!.isEmpty || text.length < 6){
                      return "Senha inválida";
                    }
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: TextButton(
                      onPressed: () {
                        if(_emailController.text.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Insira seu email para recuperação!"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: _timeForMessage),
                              )
                          );
                        }else{
                          model.recoverPass(_emailController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Email de recuperação enviado!"),
                                backgroundColor: Theme.of(context).primaryColor,
                                duration: Duration(seconds: _timeForMessage),
                              )
                          );
                        }
                      },
                      child: Text("Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                    child: Text("Entrar",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),),
                    style: ElevatedButton.styleFrom(primary: primaryColor),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){

                      }

                      model.signIn(
                          email: _emailController.text,
                          pass: _passController.text,
                          onSuccess: _onSuccess,
                          onFail: _onFail
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Falha ao entrar!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: _timeForMessage),
        )
    );
  }
}