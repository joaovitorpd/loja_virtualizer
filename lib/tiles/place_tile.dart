import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  PlaceTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100.0,
            child: Image.network(snapshot["image"],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot["title"],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0
                  ),
                ),
                Text(
                  snapshot["address"],
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                      "Ver no Mapa",
                      style: TextStyle(color: Colors.blue)
                  ),
                  onPressed: (){
                    launch("https://www.google.com/maps/search/?api=1&query=${snapshot["lat"]},"
                        "${snapshot["long"]}");
                  },
                ),
                TextButton(
                  child: Text(
                      "Ligar",
                      style: TextStyle(color: Colors.blue)
                  ),
                  onPressed: (){
                    launch("tel:${snapshot["phone"]}");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
