import 'package:flutter/material.dart';
import 'package:loja_virtualizer/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  int _timeForMessage = 3;

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if(model.isLoading)
            return Center(child: CircularProgressIndicator(),);

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Nome Completo",
                  ),
                  validator: (text){
                    if(text!.isEmpty){
                      return "Nome inválido!";
                    }
                  },
                ),
                SizedBox(height: 16.0,),
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
                SizedBox(height: 16.0,),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: "Endereço",
                  ),
                  validator: (text) {
                    if(text!.isEmpty){
                      return "Endereço inválido";
                    }
                  },
                ),
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                    child: Text("Criar Conta",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),),
                    style: ElevatedButton.styleFrom(primary: primaryColor),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){

                        Map<String, dynamic> userData = {
                          "name": _nameController.text,
                          "email": _emailController.text,
                          "address": _addressController.text
                        };

                        model.singUp(
                            userData: userData,
                            pass: _passController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail
                        );
                      }
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
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Usuário cadastrado com sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: _timeForMessage),
        )
    );
    Future.delayed(Duration(seconds: _timeForMessage)).then(
            (value) => Navigator.of(context).pop()
    );
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Falha ao cadastrar usuário!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: _timeForMessage),
        )
    );
  }
}
