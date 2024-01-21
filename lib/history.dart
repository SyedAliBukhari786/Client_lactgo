import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
        title: Center(child: Text("History")),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child:   Expanded(
          flex: 8,
          child: Container(
            // color: Colors.orange,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Orders').where("userId", isEqualTo: _user!.uid).snapshots(),
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
                          leading: Icon(Icons.circle,color: Colors.black,),
                          title: Text(products, style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(" "+farmName+"\n $formattedDate " +"at $timee"),

                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),






      ),


    ));
  }
}
