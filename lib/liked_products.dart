import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikedProducts extends StatefulWidget {
  const LikedProducts({Key? key}) : super(key: key);

  @override
  State<LikedProducts> createState() => _LikedProductsState();
}

class _LikedProductsState extends State<LikedProducts> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Liked Products'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: user != null
              ? LikedProductsList(userId: user!.uid)
              : Center(
            child: Text('User not logged in.'),
          ),
        ),
      ),
    );
  }
}

class LikedProductsList extends StatelessWidget {
  final String userId;

  LikedProductsList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('LikedProducts')
          .where('user_id', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No liked products found.'),
          );
        }

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchProductDetails(snapshot.data!.docs),
          builder: (context, productDetails) {
            if (productDetails.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (productDetails.hasError) {
              return Center(
                child: Text('Error: ${productDetails.error}'),
              );
            }

            List<Map<String, dynamic>> products = productDetails.data ?? [];

            return FutureBuilder<List<String>>(
              future: _fetchFarmNames(products.map((product) => product['UserId'])),
              builder: (context, farmNames) {
                if (farmNames.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (farmNames.hasError) {
                  return Center(
                    child: Text('Error: ${farmNames.error}'),
                  );
                }

                List<String> actualFarmNames = farmNames.data ?? [];

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    var product = products[index];
                    String productName = product['ProductName'];
                    String productType = product['ProductType'];
                    int productPrice = product['Price'];
                   // String sellerId = product['sellerId'];
                    String farmName = actualFarmNames.length > index ? actualFarmNames[index] : '';

                    return ListTile(
                      leading: Icon(Icons.circle),
                      title: Text('Product: $productName'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type: $productType'),
                          Text('Price: $productPrice'),
                          Text('Farm Name: $farmName'),
                        ],
                      ),
                      onTap: () {
                        // You can navigate to another screen or perform additional actions here
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchProductDetails(List<QueryDocumentSnapshot> likedProducts) async {
    List<Map<String, dynamic>> productDetails = [];

    for (var likedProduct in likedProducts) {
      String productId = likedProduct['product_id'];

      // Fetch product details using productId
      DocumentSnapshot productSnapshot =
      await FirebaseFirestore.instance.collection('Products').doc(productId).get();

      Map<String, dynamic> productData = productSnapshot.data() as Map<String, dynamic>;
      productDetails.add(productData);
    }

    return productDetails;
  }

  Future<List<String>> _fetchFarmNames(Iterable<String> sellerIds) async {
    List<String> farmNames = [];

    for (var sellerId in sellerIds) {
      // Fetch farm name using sellerId
      DocumentSnapshot sellerSnapshot =
      await FirebaseFirestore.instance.collection('Seller').doc(sellerId).get();

      String farmName = sellerSnapshot['Farm'];
      farmNames.add(farmName);
    }

    return farmNames;
  }
}
