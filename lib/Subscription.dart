import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Subscribe extends StatefulWidget {
  const Subscribe({Key? key});

  @override
  State<Subscribe> createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user = FirebaseAuth.instance.currentUser;




  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(child: Text('Subscription Details')),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Orders').where("subscribe", isEqualTo: "Yes").where("userId", isEqualTo: _user!.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<DocumentSnapshot> documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var document = documents[index];
                DateTime startDate =
                (document['ScheduledDate'] as Timestamp).toDate();
                DateTime currentDate = DateTime.now();

                // Convert "Products" to a list if it's a single item
                List<dynamic> products = (document['Products'] is List)
                    ? document['Products']
                    : [document['Products']];

                int totalBill = document['totalBill'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.circle),
                      title: Center(
                        child: Text(
                          'Subscription  ${index + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Products: $products'),
                          Text('Total Bill: $totalBill'),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(child: Text('Confirmed Deliveries:')),
                    SizedBox(height: 8),
                    // List dates between Scheduled Date and Current Date
                    for (var date in datesBetween(startDate, currentDate)) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('- ${formatDate(date)}'),
                            Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ],
                    Divider(),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<DateTime> datesBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dates;
  }

  String formatDate(DateTime date) {
    return DateFormat('EEEE d/M/y').format(date);
  }
}
