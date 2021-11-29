import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loja_virtualizer/datas/correios_frete.dart';
import 'package:loja_virtualizer/models/cart_model.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;


class ShipCard extends StatelessWidget {
  const ShipCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _timeForMessage = 3;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Calcular Frete",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.location_on, color: Colors.grey[500],),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu CEP"
              ),
              initialValue: "",
              onFieldSubmitted: (cepDigitado) async{
                Xml2Json xml2json = Xml2Json(); // class parse XML to JSON

                try {
                  //A variável url, com o link do webservice, possui vários parâmetros como:
                  // Cep origem;
                  // Cep destino;
                  // Código serviço (PAC ou SEDEX);
                  // Altura, Largura, Comprimento e Peso;
                  // Manual: https://www.correios.com.br/atendimento/ferramentas/sistemas/arquivos/manual-de-implementacao-do-calculo-remoto-de-precos-e-prazos
                  var url = Uri.parse(
                      "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx?nCdEmpresa=&sDsSenha=&sCepOrigem=70002900&sCepDestino=$cepDigitado&nVlPeso=1&nCdFormato=1&nVlComprimento=20&nVlAltura=20&nVlLargura=20&sCdMaoPropria=n&nVlValorDeclarado=0&sCdAvisoRecebimento=n&nCdServico=04510&nVlDiametro=0&StrRetorno=xml&nIndicaCalculo=3"
                  );

                  http.Response reponse = await http.get(url);

                  //print("GET DO XML");
                  //print(reponse.body);

                  if (reponse.statusCode == 200) {
                    xml2json.parse(reponse.body);

                    var resultMap = xml2json.toGData();

                    CorreiosFrete correios = CorreiosFrete.fromJson(
                        json.decode(resultMap)["Servicos"]["cServico"]);

                    CartModel.of(context).setShipPrice(correios.valor);
                    CartModel.of(context).setShippingDeadline(correios.prazo);
                    //print(CartModel.of(context).getShipPrice());
                    //print(CartModel.of(context).shippinDeadline);


                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "R\$ ${CartModel.of(context).getShipPrice()} reais \nPrazo da entrega: ${CartModel.of(context).shippinDeadline} dias"),
                          backgroundColor: Theme.of(context).primaryColor,
                          duration: Duration(seconds: _timeForMessage),
                        )
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Erro de conexão: ${reponse.statusCode}"),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: _timeForMessage),
                        )
                    );
                  }
                } catch (erro) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(erro.toString()),
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: _timeForMessage),
                      )
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
