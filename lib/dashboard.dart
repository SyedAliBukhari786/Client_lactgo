import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lactgo_user/bookandscdule.dart';
import 'package:lactgo_user/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user = FirebaseAuth.instance.currentUser;

  late Stream<QuerySnapshot> productStream;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;

    // Check if the tip has already been shown
    _checkTipStatus().then((tipShown) {
      if (!tipShown) {
        // If the tip hasn't been shown, fetch and show it
        _showRandomTip();
      }
    });

    // Initialize productStream based on the default filter
    productStream = FirebaseFirestore.instance
        .collection('Products')
        .snapshots(includeMetadataChanges: true);
  }
  Future<void> _likeTip(String tipId) async {
    User? user = _auth.currentUser;
    String userId = user?.uid ?? '';

    // Add the LikedTip document to the collection
    await FirebaseFirestore.instance.collection('LikedTips').add({
      'tip': tipId,
      'userId': userId,
    });

    // You can also update the UI or perform any other actions as needed
    print('Tip Liked!');
  }


  Future<bool> _checkTipStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tipShown') ?? false;
  }

  Future<void> _setTipStatus(bool tipShown) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tipShown', tipShown);
  }
  Future<void> _showRandomTip() async {


    print("Showing random tip...");
    QuerySnapshot tipsSnapshot =
    await FirebaseFirestore.instance.collection('Tips').get();

    if (tipsSnapshot.docs.isNotEmpty) {
      // Randomly select a tip
      int randomIndex = tipsSnapshot.docs.length > 1
          ? (tipsSnapshot.docs.length * 0.5).floor() // Change this logic as needed
          : 0;
      String randomTipId = tipsSnapshot.docs[randomIndex].id;
      String randomTip = tipsSnapshot.docs[randomIndex]['tip'];


      // Show the tip in a dialog box
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tip of the Day'),
            content: Center(
              child: Container(
                constraints: BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(randomTip),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up,color: Colors.green,),
                            onPressed: () {
                              _likeTip(randomTipId);
                              Navigator.of(context).pop(); // Close the dialog
                              _setTipStatus(true);// Pass the Tip ID when the like button is pressed
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle OK button press
                              Navigator.of(context).pop(); // Close the dialog
                              _setTipStatus(true); // Mark the tip as shown
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }




  int a=0;

  bool isclicked= true;






  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFFFEF3E5);
    double ScreenHeight = MediaQuery.of(context).size.height;
    double ScreenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: ScreenWidth * 0.1 > 400 ? ScreenWidth * 0.2  : ScreenWidth * 0.25,
          title:  Text(
            'LACT GO',
            style: TextStyle(
                fontSize:  ScreenWidth * 0.09 > 400 ? 30 : ScreenWidth * 0.09, fontWeight: FontWeight.bold,color: Colors.white),
          ),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(60.0),
              bottomRight: Radius.circular(60.0),
            ),
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                // color: Colors.yellow,
                 height: ScreenHeight*0.1,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Your button click logic here
                                  setState(() {
                                    isclicked=!isclicked;
                                    productStream= FirebaseFirestore.instance
                                        .collection('Products')
                                   //  .where("U", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                                        .snapshots(includeMetadataChanges: true);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  primary: isclicked? myColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Container(
                                  height: 30.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Trending Products',
                                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                                  ),
                                ),
                              ),SizedBox(width: 10,),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isclicked=!isclicked;
                                    productStream= FirebaseFirestore.instance
                                        .collection('Products')
                                      .where("Discount", isNotEqualTo: a)
                                        .snapshots(includeMetadataChanges: true);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  primary: isclicked? Colors.white:  myColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: Container(
                                  height: 30.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Discount Sale/Offer',
                                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                                  ),
                                ),
                              ),




                            ],
                    ),
                  ),
                ),
                GestureDetector(  onTap: () {
                  setState(() {
                    productStream= FirebaseFirestore.instance
                        .collection('Products')
                        .where("ProductType", isEqualTo: "Cow")
                        .snapshots(includeMetadataChanges: true);
                  });
                ;
                },
                  child: Container(
                  //  height: 100,
                    //color: Colors.green,
                    child:  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      Container(
                      width: MediaQuery.of(context).size.width*0.18,

                      height: MediaQuery.of(context).size.width*0.18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.orange,
                          width: 2.0,
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/cow.png",

                          height: 40,
                          width: 40,


                          // Adjust the height as needed
                        ),
                      ),
                    ),

                          SizedBox(width: 20,),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                productStream= FirebaseFirestore.instance
                                    .collection('Products')
                                    .where("ProductType", isEqualTo: "Goat")
                                    .snapshots(includeMetadataChanges: true);
                              });

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.18,

                              height: MediaQuery.of(context).size.width*0.18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/goat.png",

                                  height: 40,
                                  width: 40,


                                  // Adjust the height as needed
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                productStream= FirebaseFirestore.instance
                                    .collection('Products')
                                    .where("ProductType", isEqualTo: "Camel")
                                    .snapshots(includeMetadataChanges: true);
                              });

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.18,

                              height: MediaQuery.of(context).size.width*0.18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/camel.png",

                                  height: 40,
                                  width: 40,


                                  // Adjust the height as needed
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                productStream= FirebaseFirestore.instance
                                    .collection('Products')
                                    .where("ProductType", isEqualTo: "Buffalo")
                                    .snapshots(includeMetadataChanges: true);
                              });

                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.18,

                              height: MediaQuery.of(context).size.width*0.18,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/buffalo.png",

                                  height: 40,
                                  width: 40,


                                  // Adjust the height as needed
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  //  height: 100,
                  //color: Colors.green,
                  child:  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              productStream= FirebaseFirestore.instance
                                  .collection('Products')
                                  .where("ProductName", isEqualTo: "Milk")
                                  .snapshots(includeMetadataChanges: true);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            primary:  myColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Container(
                            height: 30.0,
                            alignment: Alignment.center,
                            child: Text(
                              'Milk',
                              style: TextStyle(fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),

                        ElevatedButton(
                          onPressed: () {
                            setState(() {

                              productStream= FirebaseFirestore.instance
                                  .collection('Products')
                               .where("ProductName", isEqualTo: "Yogurt")
                                  .snapshots(includeMetadataChanges: true);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            primary:  Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Container(
                            height: 30.0,
                            alignment: Alignment.center,
                            child: Text(
                              'Yogurt',
                              style: TextStyle(fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              productStream= FirebaseFirestore.instance
                                  .collection('Products')
                                  .where("ProductName", isEqualTo: "Cheese")
                                  .snapshots(includeMetadataChanges: true);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            primary:  myColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Container(
                            height: 30.0,
                            alignment: Alignment.center,
                            child: Text(
                              'Cheese',
                              style: TextStyle(fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),

                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              productStream= FirebaseFirestore.instance
                                  .collection('Products')
                                  .where("ProductName", isEqualTo: "Butter")
                                  .snapshots(includeMetadataChanges: true);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            primary:  Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Container(
                            height: 30.0,
                            alignment: Alignment.center,
                            child: Text(
                              'Butter',
                              style: TextStyle(fontSize: 16.0, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
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
              ],

            ),
          ),






        ),
      ),
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

class CircularContainer extends StatelessWidget {
  final String imagePath;

  const CircularContainer({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.18,

      height: MediaQuery.of(context).size.width*0.18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.orange,
          width: 2.0,
        ),
        color: Colors.white,
      ),
      child: Center(
        child: Image.asset(
          imagePath,

          height: 40,
          width: 40,


          // Adjust the height as needed
        ),
      ),
    );
  }



}
