import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lactgo_user/bookandscdule.dart';

class ProductsNearMe extends StatefulWidget {
  final String farmId;


  const ProductsNearMe({Key? key, required this.farmId}) : super(key: key);

  @override
  _ProductsNearMeState createState() => _ProductsNearMeState();
}

class _ProductsNearMeState extends State<ProductsNearMe> {
  late Stream<QuerySnapshot> productStream;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    productStream = FirebaseFirestore.instance
        .collection('Products').where("UserId",isEqualTo: widget.farmId)
        .snapshots(includeMetadataChanges: true);
    _user = _auth.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    double ScreenHeight = MediaQuery.of(context).size.height;
    double ScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Products Near Me'),
      ),
      body:
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:productStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    var product = snapshot.data!.docs;

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: product.length,
                      itemBuilder: (context, index) {
                        var productData = product[index].data() as Map<String, dynamic>;
                        var productId = product[index].id;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Book(productId: productId)),
                            );
                          },
                          child: Container(
                            width: ScreenWidth*0.35,
                            height: ScreenWidth*0.45,
                            decoration: BoxDecoration(
                              color: Color(0xFFFFF0DC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Container(

                                        //color: Colors.green,
                                          child: Image.asset(getImagePath(productData["ProductName"]),fit: BoxFit.cover ,)
                                      ),
                                    ),
                                  ),
                                ),






                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 4,bottom: 3),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        productData['ProductName'],
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.06,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      GestureDetector(onTap :
                                          () async {
                                            CollectionReference likedProductsCollection = FirebaseFirestore.instance.collection('LikedProducts');

                                            // Check if the document exists with the given conditions
                                            QuerySnapshot querySnapshot = await likedProductsCollection
                                                .where('product_id', isEqualTo: productId )
                                                .where('user_id', isEqualTo: _user!.uid)
                                                .get();
                                            if (querySnapshot.docs.isEmpty) {
                                              // Add data to the LikedProducts collection
                                              await likedProductsCollection.add({
                                                'product_id': productId,
                                                'user_id': _user!.uid,
                                                // Add other fields as needed
                                              });

                                              showSnackBar("Product added into liked products", Colors.green);
                                            } else {
                                              showSnackBar("Product already exists in liked products", Colors.green);
                                            }

                                      },child: Icon(Icons.heart_broken_rounded,color: Colors.red,))

                                    ],
                                  ),
                                ),
                                Padding(

                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Text(
                                    productData["ProductType"],
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),

                                Padding(

                                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "RS " ,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        '${productData['Price']}/:',
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width * 0.05,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),



                                // Add other product details if needed
                              ],
                            ),
                          ),
                        );
                      },





                    );
                  },
                ),
              ),
            ],),
          ),
        )
    );
  }
  String getImagePath(String productName) {
    if (productName == null) {
      return "assets/default.png"; // Provide a default image path if productName is null
    } else if (productName == "Butter") {
      return "assets/butter.png";
    } else if (productName == "Cheese") {
      return "assets/cheese.png";
    } else if (productName == "Yogurt") {
      return "assets/yogurt.png";
    } else if (productName == "Milk") {
      return "assets/milk.png";
    } else {
      return "assets/milk.png"; // Provide a default image path for unknown products
    }
  }
  void showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
      ),
    );
  }
}
