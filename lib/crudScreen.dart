import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_skeleton/skeleton.dart';
import 'package:flutter/material.dart';

// Firestore stuff
CollectionReference firebaseCollection =
    FirebaseFirestore.instance.collection('products');

class CrudScreen extends StatefulWidget {
  @override
  _CrudScreenState createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  TextEditingController productName = TextEditingController();
  TextEditingController productPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Crud Screen'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: 10),
        child: Column(children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                InputForm(
                  controller: productName,
                  labelText: 'Product Name',
                  icon: Icons.add_box,
                ),
                smallGapHere,
                InputForm(
                  controller: productPrice,
                  labelText: 'Price',
                  icon: Icons.monetization_on,
                ),
                smallGapHere,
                ElevatedButton(
                  onPressed: () async {
                    await firebaseCollection.add({
                      'productName': productName.text,
                      'productPrice': productPrice.text
                    }).whenComplete(() {
                      productName.clear();
                      productPrice.clear();
                      FocusScope.of(context).unfocus();
                      print('Product Added');
                    });
                  },
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
          Center(
              child: Text(
            'All Product List',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          )),
          Divider(),
          Text('*swipe to delete'),
          Text('*press the pen to edit'),
          Expanded(
            child: StreamBuilder(
                stream: firebaseCollection.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  } else if (snapshot.hasData) {
                    List products = snapshot.data.docs;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          background: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.red,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                )),
                          ),
                          key: UniqueKey(),
                          onDismissed: (value) {
                            setState(() {
                              snapshot.data.docs[index].reference.delete();
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Card(
                              child: ListTile(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => UpdateProduct(
                                            productList: products,
                                            index: index,
                                          ));
                                },
                                title: Text(products[index]['productName']),
                                subtitle: Text(
                                    '\$ ${products[index]['productPrice']}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => UpdateProduct(
                                              productList: products,
                                              index: index,
                                            ));
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return CircularProgressIndicator();
                }),
          )
        ]),
      ),
    );
  }
}

class UpdateProduct extends StatelessWidget {
  const UpdateProduct({
    Key key,
    @required this.productList,
    @required this.index,
  }) : super(key: key);

  final List productList;
  final int index;

  @override
  Widget build(BuildContext context) {
    TextEditingController productName = TextEditingController();
    TextEditingController productPrice = TextEditingController();

    productName.text = productList[index]['productName'];
    productPrice.text = productList[index]['productPrice'];

    return Dialog(
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Product Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              smallGapHere,
              InputForm(
                controller: productName,
                labelText: 'Product Name',
                icon: Icons.add_box,
              ),
              smallGapHere,
              InputForm(
                  controller: productPrice,
                  labelText: 'Price',
                  icon: Icons.monetization_on),
              ElevatedButton(
                onPressed: () {
                  firebaseCollection.get().then((snapshot) {
                    snapshot.docs[index].reference.update({
                      'productName': productName.text,
                      'productPrice': productPrice.text,
                    });
                    print('Update Done');
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Update Product',
                ),
              ),
            ],
          )),
    );
  }
}
