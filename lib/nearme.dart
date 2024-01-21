import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lactgo_user/nearme.dart';
import 'package:lactgo_user/productsnearme.dart';

class Nearmefarms extends StatefulWidget {
  const Nearmefarms({Key? key}) : super(key: key);

  @override
  State<Nearmefarms> createState() => _NearmefarmsState();
}

class _NearmefarmsState extends State<Nearmefarms> {
  late String userId;
  String city='';// Variable to store the current user ID

  @override
  void initState() {
    super.initState();
    // Fetch the current user ID when the widget initializes
    getUserId();
  }

  Future<void> getUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      fetchData();
    }
  }


  Future<void> fetchData() async {
    try {
      // Query "Orders" collection using productId
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      if (orderSnapshot.exists) {
        // Retrieve fields from the "Orders" collection
        setState(() {
          city = orderSnapshot['City'];

        });

        // Query "Sellers" collection using userId

      } else {
        // Handle the case where the order with the provided productId does not exist
      }
    } catch (error) {
      // Handle any errors that may occur during the queries
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(child: Text('Nearby Farms')),
        ),
        body: _buildFarmList(),
      ),
    );
  }

  Widget _buildFarmList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Seller').where("City",isEqualTo: city).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(); // Show loading indicator
        }

        var farms = snapshot.data?.docs; // Get the documents from the snapshot

        return ListView.builder(
          itemCount: farms!.length,
          itemBuilder: (context, index) {
            var farmData = farms[index].data() as Map<String, dynamic>;
            var farmName = farmData['Farm'] ?? 'No Name';
            var farmId = farms[index].id;

            return ListTile(
              leading: Image.asset('assets/cow.png'), // Replace with your cow image
              title: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(farmName, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.06, fontWeight: FontWeight.bold),),
              ),
              onTap: () {
                _navigateToProductsPage(farmId);
              },
            );
          },
        );
      },
    );
  }

  void _navigateToProductsPage(String farmId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsNearMe(farmId: farmId),
      ),
    );
  }
}
