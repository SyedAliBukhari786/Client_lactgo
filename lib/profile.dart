
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lactgo_user/Subscription.dart';
import 'package:lactgo_user/cart.dart';
import 'package:lactgo_user/history.dart';
import 'package:lactgo_user/login.dart';
import 'package:lactgo_user/liked_products.dart';
import 'package:lactgo_user/saved_tips.dart';
import 'package:lactgo_user/editprofile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  String userName = ''; // to store the user name

  @override
  void initState() {
    super.initState();
    fetchData(); // fetch data when the widget is initialized
  }


  Future<void> fetchData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      // Replace 'yourCollection' with the actual collection name
      // Replace 'yourUserId' with the actual user ID
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection('Users').doc(user?.uid).get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Replace 'name' with the actual field name you want to retrieve
        String name = documentSnapshot.data()?['name'] ?? 'User';

        setState(() {
          userName = name;
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }



  @override
  Widget build(BuildContext context) {





    Color myColor = Color(0xFFFEF3E5);



    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
             //   mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.33 : MediaQuery.of(context).size.width * 0.33,
                        height: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.33 : MediaQuery.of(context).size.width * 0.33,
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
                      SizedBox(
                        height: 5,
                      ),
                      Text("$userName",  style: TextStyle(
                        color: Colors.black,
                        fontSize:screenWidth * 0.04 > 400 ? 30 : screenWidth *0.08,
                        fontWeight: FontWeight.bold,
                      ),
                      ),


                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Users",  style: TextStyle(
                    color: Colors.grey,
                    fontSize:screenWidth * 0.04 > 400 ? 30 : screenWidth *0.06,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    width: screenWidth * 0.8 > 400 ? 200 : screenWidth * 0.5,
                    child: ElevatedButton(
                      onPressed: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Editprofile()),
                       );



                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child:
                             Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 40,
                  ),


                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => History()),
                  );
                },
                    child: Container(

                      //color: Colors.white,
                      width: screenWidth *0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text("History", style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth *0.048,
                            fontWeight: FontWeight.bold,
                          ),),

                          Container(
                            width: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.06 : MediaQuery.of(context).size.width * 0.1 ,
                            height: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.06  : MediaQuery.of(context).size.width * 0.1 ,
                            decoration: BoxDecoration(
                              color:  myColor ,
                              shape: BoxShape.circle,
                              // Set the shape to circular
                              border: Border.all(
                                color: Colors.black,
                                width: 0.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    // Replace with the desired icon
                                    // size: 40.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),


                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Subscribe()),
                      );
                    },
                    child: Container(

                      //color: Colors.white,
                      width: screenWidth *0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text("Subscribed Products", style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth *0.048,
                            fontWeight: FontWeight.bold,
                          ),),

                          Container(
                            width: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.06 : MediaQuery.of(context).size.width * 0.1 ,
                            height: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.06  : MediaQuery.of(context).size.width * 0.1 ,
                            decoration: BoxDecoration(
                              color:  myColor ,
                              shape: BoxShape.circle,
                              // Set the shape to circular
                              border: Border.all(
                                color: Colors.black,
                                width: 0.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    // Replace with the desired icon
                                    // size: 40.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),


                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {

                  Navigator.push(
                    context,
                      MaterialPageRoute(builder: (context) => LikedProducts()),
                    );




                    },
                    child: Container(
                     // color: Colors.green,

                      //color: Colors.white,
                      width: screenWidth *0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text("Liked Products", style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth *0.048,
                            fontWeight: FontWeight.bold,
                          ),),

                      Container(
                              width: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.06 : MediaQuery.of(context).size.width * 0.1 ,
                              height: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.06  : MediaQuery.of(context).size.width * 0.1 ,
                              decoration: BoxDecoration(
                                color:   myColor ,
                                shape: BoxShape.circle,
                                // Set the shape to circular
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.0,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      // Replace with the desired icon
                                      // size: 40.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),



                        ],
                      ),


                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Cart()),
                      );




                    },
                    child: Container(
                      // color: Colors.green,

                      //color: Colors.white,
                      width: screenWidth *0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text("Cart", style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth *0.048,
                            fontWeight: FontWeight.bold,
                          ),),

                          Container(
                            width: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.06 : MediaQuery.of(context).size.width * 0.1 ,
                            height: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.06  : MediaQuery.of(context).size.width * 0.1 ,
                            decoration: BoxDecoration(
                              color:   myColor ,
                              shape: BoxShape.circle,
                              // Set the shape to circular
                              border: Border.all(
                                color: Colors.black,
                                width: 0.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    // Replace with the desired icon
                                    // size: 40.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),



                        ],
                      ),


                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SavedTips()),
                    );


                  },
                    child: Container(

                      //color: Colors.white,
                      width: screenWidth *0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text("Saved Tips", style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth *0.048,
                            fontWeight: FontWeight.bold,
                          ),),

                          Container(
                            width: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.06 : MediaQuery.of(context).size.width * 0.1 ,
                            height: MediaQuery.of(context).size.width<500? MediaQuery.of(context).size.width * 0.06  : MediaQuery.of(context).size.width * 0.1 ,
                            decoration: BoxDecoration(
                               color:  myColor ,
                              shape: BoxShape.circle,
                              // Set the shape to circular
                              border: Border.all(
                                color: Colors.black,
                                width: 0.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    // Replace with the desired icon
                                    // size: 40.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),


                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // Perform the logout operation
                      await FirebaseAuth.instance.signOut();

                      // Navigate to the login screen or any other screen you want after logout
                      // Example using Navigator:
                      Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => LoginPage()),
                     );
                    },
                    child: Container(

                      //color: Colors.white,
                      width: screenWidth *0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text("logout", style: TextStyle(
                            color: Colors.red,
                            fontSize: screenWidth *0.048,
                            fontWeight: FontWeight.bold,
                          ),),




                        ],
                      ),


                    ),
                  ),
                  SizedBox(height: 100,)



                ],








                ),
              ),
            ),
          ),
        ),








      ),
    );;
  }
}
