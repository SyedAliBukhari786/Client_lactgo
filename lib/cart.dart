import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user = FirebaseAuth.instance.currentUser;
  String _getDayOfWeek(int day) {
    List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return daysOfWeek[day - 1];
  }



  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;

  }
  @override
  Widget build(BuildContext context) {
    double ScreenHeight = MediaQuery.of(context).size.height;
    double ScreenWidth = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
appBar: AppBar(
  title: Center(child: Text("My Cart")),
),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child:  Column(
          children: [
            Expanded(
              flex: 9,
              child: Container(
                // color: Colors.orange,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Orders').where("status", isEqualTo: "Added_to_cart").where("userId", isEqualTo: _user!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    // Process the data
                    List<DocumentSnapshot> orders = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        // Extract data from each order document
                        String sellerId = orders[index]['sellerId'];
                        String products = orders[index]['Products'];
                        String timee = orders[index]['ScheduledTime'];
                        int price= orders[index]["totalBill"];
                        Timestamp scheduledDateTimestamp = orders[index]['ScheduledDate'];
                        DateTime scheduledDate = scheduledDateTimestamp.toDate();
                        String formattedDate =
                            "${_getDayOfWeek(scheduledDate.weekday)} ${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}";

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('Seller').doc(sellerId).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return ListTile(
                                title: Text('Loading...'),
                              );
                            }

                            if (snapshot.hasError) {
                              return ListTile(
                                title: Text('Error: ${snapshot.error}'),
                              );
                            }

                            // Extract the "Farmname" field from the seller document
                            String farmName = snapshot.data!['Farm'];

                            // Display the data in a ListTile or any other widget
                            return ListTile(

                              title: Text(products, style: TextStyle(fontWeight: FontWeight.bold),),
                              subtitle: Text(""+farmName+"\n Bill: $price"),
                              leading: GestureDetector(
                                  onTap: () {

                                    FirebaseFirestore.instance.collection('Orders').doc(orders[index].id).delete();
                                  },
                                  child: Icon(Icons.delete,color: Colors.red,)),

                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded( flex :1,child: Container( child:
            Container(
              width: ScreenWidth * 0.8 > 400 ? 400 : ScreenWidth * 0.8,
              child: ElevatedButton(
                onPressed: () async {
                  QuerySnapshot cartSnapshots = await FirebaseFirestore.instance
                      .collection('Orders')
                      .where("status", isEqualTo: "Added_to_cart")
                      .where("userId", isEqualTo: _user!.uid)
                      .get();

                  for (QueryDocumentSnapshot cartSnapshot in cartSnapshots.docs) {
                    await FirebaseFirestore.instance
                        .collection('Orders')
                        .doc(cartSnapshot.id)
                        .update({'status': 'Pending'});
                  }

                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),)),
            SizedBox(height: 10,),
          ],
        ),
      ),



    ));
  }
}
