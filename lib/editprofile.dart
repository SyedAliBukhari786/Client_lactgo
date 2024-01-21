import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  TextEditingController name=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController cnic=TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;

    _firestore.collection('Users').doc(_user?.uid).get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          name.text = snapshot['name'] ?? '';
          phone.text = snapshot['phone'] ?? '';
          cnic.text = snapshot['City'] ?? '';
        });
      }
    });
  }
  Future<void> _saveProfile() async {
    if(name.text.isEmpty){
      _showErrorSnackbar("Name cannot be Empty");
    }
    else if  (phone.text.isEmpty){
      _showErrorSnackbar("Contact cannot be Empty");
    }
    else if (cnic.text.isEmpty){
      _showErrorSnackbar("City cannot be Empty");
    }
    else {
      setState(() {
        _loading = true;
      });

      try {
        await _firestore.collection('Users').doc(_user?.uid).update({
          'name': name.text,
          'contact': phone.text,
          'City': cnic.text,
        });

        // Successful update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        // Handle error
        print('Error updating profile: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _loading = false;
        });
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: GestureDetector(
              onTap: () {



              },
              child: Container(
                // color: Color,
                height: screenHeight * 0.1,

                child:  Container(
                  width: screenWidth * 0.8 > 400 ? 400 : screenWidth * 0.8,
                  child: ElevatedButton(
                    onPressed: _loading ? null : () => _saveProfile(), // Handle button press

                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: _loading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),

              )),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.blue,
              ),
              onPressed: () {
                // Navigate to the login page when the back button is pressed
                Navigator.pop(context);
              },
            ),
            toolbarHeight:
            screenWidth * 0.1 > 400 ? screenWidth * 0.15 : screenWidth * 0.18,
            title: Center(
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.09 > 400 ? 30 : screenWidth * 0.07,
                      fontWeight: FontWeight.bold),
                )),
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60.0),
                bottomRight: Radius.circular(60.0),
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: screenWidth * 0.8 > 400 ? 400 : screenWidth *
                    0.8,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Center(
                          child: Container(
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
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text("Edit Profile",  style: TextStyle(
                            color: Colors.black,
                            fontSize:screenWidth * 0.04 > 400 ? 30 : screenWidth *0.08,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                        SizedBox(height: 10,),




                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            "User Name",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        TextField(
                          style: TextStyle(color: Colors.black),
                          controller: name,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            "Contact",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        TextField(
                          style: TextStyle(color: Colors.black),

                          controller: phone,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            "City",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        TextField(
                          style: TextStyle(color: Colors.orange),
                          controller: cnic,

                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                          ),
                        ),





                      ]),
                ),



              ),
            ),
          ),
        ));
  }
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
