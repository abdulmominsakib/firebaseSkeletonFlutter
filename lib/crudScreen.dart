import 'package:flutter/material.dart';

class CrudScreen extends StatefulWidget {
  @override
  _CrudScreenState createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Crud Screen'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(children: [
          Center(
              child: Text(
            'All Product List',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          )),
          Divider(),
        ]),
      ),
    );
  }
}
