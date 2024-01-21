import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class Scedule extends StatefulWidget {
  const Scedule({super.key});

  @override
  State<Scedule> createState() => _SceduleState();
}

class _SceduleState extends State<Scedule> {


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
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

    // Check if the tip has already been shown


  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    // Format the date as "April/Year"
    String formattedDate2 = DateFormat('MMMM/yyyy').format(currentDate);
    Color myColor2 = Color(0xFF232F3E);
    double ScreenHeight = MediaQuery.of(context).size.height;
    double ScreenWidth = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(




      body: Container(
        width: double.infinity,
        height: double.infinity,
       // color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
             Container(
                  color:   myColor2 ,
               height: ScreenHeight*0.55,
               child:Column(
                 children: [
                   Expanded(
                       flex:3,child: Container(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.center,

                       children: [
                         SizedBox(width: 10,),
                         Text(formattedDate2,style: TextStyle(fontSize: ScreenWidth*0.08,color: Colors.white),),
                         SizedBox(width: 10,),
                         Container(
                           width: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.23 : MediaQuery.of(context).size.width * 0.23,
                           height: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.23 : MediaQuery.of(context).size.width * 0.23,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             shape: BoxShape.circle,
                             // Set the shape to circular
                             border: Border.all(
                               color: Colors.green,
                               width: 0.0,
                             ),
                           ),
                           child: Padding(
                             padding: const EdgeInsets.all(2.0),
                             child: Center(
                               child: FittedBox(
                                 fit: BoxFit.contain,
                                 child: Icon(
                                   Icons.person,
                                   // Replace with the desired icon
                                   // size: 40.0,
                                   color: Colors.green,
                                 ),
                               ),
                             ),
                           ),
                         ),
                         SizedBox(width: 10,),
                         
                       ],
                     ),
                   )),
                   Expanded(
                     flex: 7,
                     child: Container(
                       color: Colors.black,
                       child: SingleChildScrollView(
                         child: Column(
                           children: [
                             // ... (other widgets)
                             Container(
                               padding: EdgeInsets.all(8.0),
                               color: myColor2,
                               child: TableCalendar(
                                 firstDay: DateTime.utc(2000, 1, 1),
                                 lastDay: DateTime.utc(2030, 12, 31),
                                 focusedDay: _focusedDay,
                                 calendarFormat: _calendarFormat,
                                 startingDayOfWeek: StartingDayOfWeek.monday,
                                 calendarStyle: CalendarStyle(
                                   selectedDecoration: BoxDecoration(
                                     color: Colors.orange,
                                     shape: BoxShape.circle,
                                   ),
                                   todayDecoration: BoxDecoration(
                                     color: Colors.blue,
                                     shape: BoxShape.circle,
                                   ),
                                 ),
                                 onFormatChanged: (format) {
                                   setState(() {
                                     _calendarFormat = format;
                                   });
                                 },
                                 onPageChanged: (focusedDay) {
                                   setState(() {
                                     _focusedDay = focusedDay;
                                   });
                                 },
                                 onDaySelected: (selectedDay, focusedDay) {
                                   setState(() {
                                     _selectedDay = selectedDay;
                                   });
                                 },
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),


                 ],
               ),


                ),

              Stack(
              children:[

                // no use of this container in code just for layout design
                Container(
                  height: ScreenHeight*0.45,

               color: myColor2,



                ),
                Container(
                  height: ScreenHeight*0.45,


                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft:
                      Radius.circular(50.0),
                      topRight:
                      Radius.circular(50.0),// Adjust the radius as needed
                    ),
                  ),

                  child: Column(
                    children: [
                      Expanded(
                          flex:1
                          ,child: Container(//color: Colors.lightBlue,
                      child:  Container(

                        width: ScreenWidth * 0.4 > 400 ? 400 : ScreenWidth * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ElevatedButton(
                            onPressed: () {

                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      )),
                      Expanded( flex:1,child: Container(
                      //  color: Colors.red,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text("Schedule",style: TextStyle(fontSize: ScreenWidth*0.06,fontWeight: FontWeight.bold),),
                      ),
                      )),
                      Expanded(
                        flex: 8,
                        child: Container(
                         // color: Colors.orange,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('Orders').where("status", isEqualTo: "Pending").where("userId", isEqualTo: _user!.uid).snapshots(),
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
                      )

                    ],

                  ),
                ),
              ]
              ),

            ],
          ),
        ),
      ),
    ));
  }
}
