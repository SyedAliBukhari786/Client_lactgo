



import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';

class Regisration extends StatefulWidget {
  const Regisration({super.key});

  @override
  State<Regisration> createState() => _RegisrationState();
}

class _RegisrationState extends State<Regisration> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confrimpassword = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _name= TextEditingController();
  final TextEditingController _contact= TextEditingController();
  String name="";
  String contact="";
  String eamil = "";
  String password = "";
  String confirmpassword = "";
  String bio = "";
  String role = "";
  String city = "";




  final TextEditingController _role = TextEditingController();

  final TextEditingController _city = TextEditingController();
  String _selectedCity = "Select City";

  bool _loading = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    List<String> list = [
      "Select City",
      'Abbottabad',
      'Bahawalpur',
      'Faisalabad',
      'Gujranwala',
      'Islamabad',
      'Karachi',
      'Lahore',
      'Multan',
      'Peshawar',
      'Quetta',
      'Rawalpindi',
      'Sialkot',
      // Add more cities as needed
    ];
    String dropdownValue = list.first;
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar: GestureDetector(
              onTap: () {
                // Handle registration action here

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Container(
                color: Color(0xFF232F3E),
                height: screenHeight * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " Login",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
          backgroundColor: Color(0xFF232F3E),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: screenWidth * 0.08,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.04,
                    ),
                    Text(
                      "Create your account for best selling\nexperience",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                        screenWidth * 0.04 > 400 ? 400 : screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: screenWidth * 0.8 > 400 ? 400 : screenWidth *
                            0.8,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Seller Name",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.white),
                                controller: _name,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Contact",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.white),
                                controller: _contact,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Email",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.white),
                                controller: _emailController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Bio",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.orange),
                                controller: _bio,
                              //  inputFormatters: [CNICFormatter()],
                               // keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.add_card_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Password",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.orange),
                                obscureText: !isPasswordVisible,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Confirm Password",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.orange),
                                obscureText: !isPasswordVisible,
                                controller: _confrimpassword,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: screenHeight * 0.04,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Role",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.orange),
                                controller: _role,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.location_city_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "Location",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              TextField(
                                style: TextStyle(color: Colors.orange),
                                controller: _city,
                                readOnly: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Center(
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(
                                      Icons.arrow_drop_down_outlined),
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.orange),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.orange,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                      _city.text = dropdownValue;
                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                ),
                              ),



                              Container(
                                width: screenWidth * 0.8 > 400
                                    ? 400
                                    : screenWidth * 0.8,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _loading ? null : _Signup();


                                    // Handle button press
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: _loading
                                        ? CircularProgressIndicator(
                                        color: Colors.white)
                                        : Text(
                                      'Sign up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    )
                  ],
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

  void _showErrorSnackbar2(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> _Signup() async {
    setState(() {
      _loading = true;
    });
name=_name.text.trim();
    eamil = _emailController.text.trim();
    password = _passwordController.text.trim();
    confirmpassword = _confrimpassword.text.trim();
    bio = _bio.text.trim();
    role = _role.text.trim();
    city = _city.text.trim();
    contact=_contact.text.trim();

    // Regular expression for basic email validation
    final emailRegex =
    RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

   /* if (profileurl.isEmpty) {
      _showErrorSnackbar("Select Profile photo");
    } else if (certificate.isEmpty) {
      _showErrorSnackbar("Select Certificate");
    } else */

    if (name.isEmpty) {
      _showErrorSnackbar("Name is required");
    }
    else if (contact.isEmpty) {
      _showErrorSnackbar("Contact is required");
    }
     else if (eamil.isEmpty) {
      _showErrorSnackbar("Email is required");
    } else if (!emailRegex.hasMatch(eamil)) {
      _showErrorSnackbar("Enter a valid email address");
    } else if (password.isEmpty) {
      _showErrorSnackbar("Password is required");
    } else if (password.length < 8) {
      _showErrorSnackbar("Password must be at least 8 characters");
    } else if (confirmpassword.isEmpty) {
      _showErrorSnackbar("Confirm Password is required");
    } else if (password != confirmpassword) {
      _showErrorSnackbar("Passwords do not match");
    } else if (bio.isEmpty) {
      _showErrorSnackbar("Bio is required");
    } else if (role.isEmpty) {
      _showErrorSnackbar("Role  is required");
    } else if (city.isEmpty) {
      _showErrorSnackbar("City is required");
    }
    else if (city==("Select City")) {
      _showErrorSnackbar("Select city");
    }


    else {
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: eamil,
          password: password,
        );

        String uid = userCredential.user!.uid;





        await FirebaseFirestore.instance.collection("Users").doc(uid).set({
          'email': eamil,
          'name': name,
          "phone":contact,
          'Bio': bio,
          'role': role,
          'City': city,
          "uid" : uid,




          // Add other fields you want to store
        });
        _showErrorSnackbar2("Registration Successfull");
        Navigator.pop(context);



      }
      catch(e) {
        _showErrorSnackbar(e.toString());
      }
      finally {
        setState(() {
          _loading = false;
        });
      }

    }
    setState(() {
      _loading = false;
    });
  }


}
