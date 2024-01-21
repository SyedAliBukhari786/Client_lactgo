import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Book extends StatefulWidget {
  final String productId;

  const Book({Key? key, required this.productId}) : super(key: key);

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  TextEditingController _controller = TextEditingController();
  bool subscribe= false;
  TextEditingController _reviewController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user = FirebaseAuth.instance.currentUser;
  String address = "";
  int value = 1;
  String productID = "";
  String productName = '';
  int price = 0;
  int discount = 0;
  String userId = '';
  String farmName = '';
  String location = '';
  String type = '';
  int discountedprice = 0;


  @override
  void initState() {
    super.initState();
    productID = widget.productId;
    _controller.text = '$value';
    print(widget.productId);
    fetchData();
    _user = _auth.currentUser;
  }

  bool reviews=true;

  Future<void> fetchData() async {
    try {
      // Query "Orders" collection using productId
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .doc(widget.productId)
          .get();

      if (orderSnapshot.exists) {
        // Retrieve fields from the "Orders" collection
        setState(() {
          productName = orderSnapshot['ProductName'];
          price = orderSnapshot['Price'];
          discount = orderSnapshot['Discount'];
          type = orderSnapshot['ProductType'];
          userId = orderSnapshot['UserId'];
          if (discount != 0) {
            discountedprice = (price - (price * discount / 100)).round();
          }
        });

        // Query "Sellers" collection using userId
        DocumentSnapshot sellerSnapshot = await FirebaseFirestore.instance
            .collection('Seller')
            .doc(userId)
            .get();

        if (sellerSnapshot.exists) {
          // Retrieve fields from the "Sellers" collection
          setState(() {
            farmName = sellerSnapshot['Farm'];
            location = sellerSnapshot['City'];
          });
        }
      } else {
        // Handle the case where the order with the provided productId does not exist
      }
    } catch (error) {
      // Handle any errors that may occur during the queries
      print('Error fetching data: $error');
    }
  }

  void increment() {
    setState(() {
      value++;
      _controller.text = '$value';
    });
  }

  void decrement() {
    if (value > 1) {
      setState(() {
        value--;
        _controller.text = '$value';
      });
    }
  }

  TextEditingController _timeController = TextEditingController();

  //TextEditingController totalHoursController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  String formattedTime ="";

  late DateTime? selectedDate = null;
  late DateTime? selectedTime = null;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        // Combine the picked time with today's date to create a DateTime object
        selectedTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Update the text in the controller
        _timeController.text = '${selectedTime!.hour}:${selectedTime!.minute}';
           formattedTime =DateFormat('h:mm a').format(selectedTime!);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );

        // Update the text in the controller
        _dateController.text =
            '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFFFEF3E5);
    Color myColor2 = Color(0xFF232F3E);
    double ScreenHeight = MediaQuery.of(context).size.height;
    double ScreenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: ScreenHeight * 0.3,
                  decoration: BoxDecoration(
                    color: myColor2,
                    borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(200.0), // Adjust the radius as needed
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      getImagePath("$productName"),
                      width: ScreenHeight * 0.35, // Adjust the width as needed
                      height: ScreenHeight * 0.2, // Adjust the height as needed
                      fit: BoxFit.contain, // Adjust the fit as needed
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        //height: 46,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Experience the freshness: Indulgr in the\nCreamy Goodness of Our Daily Products",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        //color: Colors.green,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 46,
                        //  color: Colors.blue,
                        child: Center(
                          child: Image.asset(
                            'assets/reviews.png',
                            // Adjust the height as needed
                            fit: BoxFit.cover, // Adjust the fit as needed
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  height: ScreenHeight * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // SizedBox(width: 2,),
                      Text(
                        "$productName ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenWidth * 0.08),
                      ),
                      // SizedBox(width: 2,),
                      Text(
                        "RS " + "$price" + "/:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenWidth * 0.08),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  height: 1,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  height: ScreenHeight * 0.08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(width: 2,),
                      Text(
                        "Discounted Price ",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenWidth * 0.07),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        (discount == 0)
                            ? "RS " + "$price" + "/:"
                            : "RS " + "$discountedprice" + "/:",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenWidth * 0.08),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  height: ScreenHeight * 0.14,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Farm : $farmName",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenWidth * 0.04),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "Location : $location",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenWidth * 0.04),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "Type : $type",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenWidth * 0.04),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                //Scduling process
                Container(
                  width: MediaQuery.of(context).size.width * 0.82,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: TextField(
                          onTap: () {
                            _selectTime(context);
                          },
                          controller: _timeController,
                          readOnly: true, // Make the TextField read-only
                          decoration: InputDecoration(
                            labelText: 'Delivery Time',
                            labelStyle: TextStyle(color: myColor2),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(
                              Icons.watch_later,
                              color: myColor2,
                            ),
                            // Display the selected time in the TextField
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: TextField(
                          onTap: () {
                            _selectDate(context);
                          },
                          controller: _dateController,
                          readOnly: true, // Make the TextField read-only
                          decoration: InputDecoration(
                            labelText: 'Delivery Date',
                            labelStyle: TextStyle(color: myColor2),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: myColor2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: TextField(
                          controller: addresscontroller,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle: TextStyle(color: myColor2),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: myColor2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: Icon(
                              Icons.maps_home_work_outlined,
                              color: myColor2,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // Handle tap on the second icon
                                // Add your logic here
                              },
                              child: Icon(
                                Icons.location_on,
                                color: myColor2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: subscribe,
                                  onChanged: (value) {
                                    setState(() {
                                      subscribe = value!;
                                    });
                                  },
                                ),
                                Text('Montly delivery subscribtion on\nsame time daily'),
                              ],
                            ),
                          ),
                          Text('Selected: $subscribe'),
                        ],
                      ),

                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        //  height: ScreenHeight*0.14,
                        width: ScreenWidth * 0.5,
                        //color: Colors.red,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          readOnly: true,
                          // Allow interaction but prevent manual editing
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: decrement,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: increment,
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text("Quantity"),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),

                SizedBox(
                  height: 8,
                ),

                GestureDetector(onTap: () {
                  setState(() {
                    reviews=!reviews;
                  });



                },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text("Reviews",style: TextStyle(fontWeight: FontWeight.bold),),
                        (reviews==true)? Icon(Icons.arrow_drop_down): Icon(Icons.arrow_drop_up),
                      ],
                    ),
                  ),
                ),

                (reviews==false)?
                Container(
                  height: ScreenHeight*0.3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                    Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('Reviews').where("Product_id",isEqualTo: productID).snapshots(),
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

                      List<QueryDocumentSnapshot> reviewDocuments = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: reviewDocuments.length,
                        itemBuilder: (context, index) {
                          String review = reviewDocuments[index]['Review'];

                          return ListTile(
                            title: Text(review,style: TextStyle(color: Colors.black),),
                            // Add other fields you want to display
                          );
                        },
                      );
                    },
                                    ),
                              ),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Container(
                                // color: Colors.red,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: TextField(
                                    style: TextStyle(
                                        color: Colors.black),
                                    controller: _reviewController,
                                    decoration: InputDecoration(
                                      // labelStyle: TextStyle(color: Colors.white),
                                      hintText: "Your response here",
                                      hintStyle: TextStyle(
                                          color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                //color: Colors.green,
                                child: GestureDetector(
                                  onTap: () async {

                                    if(_reviewController.text.isEmpty){

                                      showSnackBar("Type something", Colors.red);
                                    }else{

                                      DateTime currentDate = DateTime.now();



                                      // Formulate the review data
                                      Map<String, dynamic> reviewData = {
                                        'User_id': _user!.uid,
                                        'Review': _reviewController.text,
                                        'timestamp': Timestamp.fromDate(currentDate),
                                        "Product_id":productID,
                                        "Reply": "",
                                        "Seller_id":userId,
                                        "status":"Unchecked",




                                      };

                                      // Save the review data to the 'reviews' collection
                                      await FirebaseFirestore.instance.collection('Reviews').add(reviewData);

                                      // Show a success message or perform any other actions as needed
                                      showSnackBar("Review submitted successfully", Colors.green);


                                    }

                                    },
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                    ),
                  ),



                ):SizedBox(),


                SizedBox(
                  height: 8,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: ScreenWidth * 0.4 > 400 ? 400 : ScreenWidth * 0.4,
                      child: ElevatedButton(
                        onPressed: () async {
                          address = addresscontroller.text.trim();
                          if (selectedTime == null) {
                            showSnackBar(
                                'Please provide specific time ', Colors.red);
                          } else if (selectedDate == null) {
                            showSnackBar('Please provide a date.', Colors.red);
                          } else if (address.isEmpty) {
                            showSnackBar(
                                'Please provide an address.', Colors.red);
                          } else {
                            int? totalprice = int.tryParse(_controller.text);
                            Timestamp currentTimestamp = Timestamp.now();
                            String subscriptionStatus = "${subscribe ?'Yes' : 'No'}";


                            await FirebaseFirestore.instance
                                .collection('Orders')
                                .add({
                              'sellerId': userId,

                              // Add other fields as needed
                              'createdAt': currentTimestamp,
                              "subscribe":subscriptionStatus,

                              'ScheduledTime': formattedTime,
                              'ScheduledDate': selectedDate,
                              'Address': address,
                              //  'Quardinates': "null",
                              // working remaining for quardinates
                              'status': "Pending",
                              'Products': "$productName",
                              "productId": productID,
                              "totalBill": price * totalprice!,
                              "totalQuantity": _controller.text,
                              "userId": _user!.uid,
                              "totalProducts": "1",
                            });

                            showSnackBar('Order Submitted', Colors.green);
                            Navigator.pop(context);
                          }

                          // Handle button press
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Buy Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: ScreenWidth * 0.4 > 400 ? 400 : ScreenWidth * 0.4,
                      child: ElevatedButton(
                        onPressed: () async {

                          address=addresscontroller.text.trim();
                          if (selectedTime == null) {
                            showSnackBar('Please provide specific time ', Colors.red);
                          }
                          else if (selectedDate == null) {
                            showSnackBar('Please provide a date.', Colors.red);
                          }
                          else  if (address.isEmpty) {
                            showSnackBar('Please provide an address.', Colors.red);
                          } else {
                            int? totalprice=int.tryParse(_controller.text);
                            Timestamp currentTimestamp = Timestamp.now();

                            String subscriptionStatus = "${subscribe ?'Yes' : 'No'}";


                            await FirebaseFirestore.instance.collection('Orders').add({
                              'sellerId': userId,

                              // Add other fields as needed
                              'createdAt': currentTimestamp,

                              "subscribe":subscriptionStatus,
                              'ScheduledTime': formattedTime,
                              'ScheduledDate': selectedDate,
                              'Address': address,
                              //  'Quardinates': "null",
                              // working remaining for quardinates
                              'status': "Added_to_cart",
                              'Products': "$productName",
                              "productId":productID,
                              "totalBill": price*totalprice!,
                              "totalQuantity":_controller.text,
                              "userId":_user!.uid,
                              "totalProducts":"1",
                            });

                            showSnackBar('Order Submitted', Colors.green);
                            Navigator.pop(context);

                          }
                          },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Add Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 40,
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
