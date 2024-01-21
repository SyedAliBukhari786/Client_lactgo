import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedTips extends StatefulWidget {
  const SavedTips({Key? key}) : super(key: key);

  @override
  State<SavedTips> createState() => _SavedTipsState();
}

class _SavedTipsState extends State<SavedTips> {
  late List<String> savedTips = []; // Initialize with an empty array
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      fetchLikedTips();
    } else {
      print('User not logged in.');
    }
  }

  Future<void> fetchLikedTips() async {
    try {
      String currentUserId = user!.uid;
      CollectionReference likedTipsCollection =
      FirebaseFirestore.instance.collection('LikedTips');

      QuerySnapshot querySnapshot = await likedTipsCollection
          .where('userId', isEqualTo: currentUserId)
          .get();

      List<String> tips = querySnapshot.docs
          .map((doc) => doc['tip'] as String)
          .toList();

      setState(() {
        savedTips = tips;
      });
    } catch (e) {
      print('Error fetching LikedTips: $e');
      // Handle the error, e.g., show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          title: Center(child: Text('Saved Tips')),
        ),
        body: savedTips.isNotEmpty
            ? ListView.builder(
          itemCount: savedTips.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.circle,color: Colors.green,),
              title: Text(savedTips[index]),
              // Add any other widget customization here
            );
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
