import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intstagram2/resources/auth_methods.dart';
import 'package:intstagram2/resources/firestore_methods.dart';
import 'package:intstagram2/screens/login_screen.dart';
import 'package:intstagram2/utils/colors.dart';
import 'package:intstagram2/utils/utils.dart';

import '../widget/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key,required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData={};
  int postLen=0;
  int followers=0;
  int following=0;
  bool isFollowing=false;
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    getData();
  }
  getData()async{
    setState(() {
      isLoading=true;
    });
    try{
     var userSnap= await FirebaseFirestore.instance
         .collection('users')
         .doc(widget.uid)
         .get();
    // get post length
     var postSnap=await FirebaseFirestore.instance
         .collection('posts')
         .where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

     postLen=postSnap.docs.length;
     userData = userSnap.data()!;
     followers=userSnap.data()!['followers'].length;
      following=userSnap.data()!['following'].length;
      isFollowing=userSnap.data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    setState(() {

    });
    }catch(e){
      showSnackBar(e.toString(),context);
    }
    setState(() {
      isLoading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return isLoading? Center(child: CircularProgressIndicator(),):
    Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userData['username']),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userData['photoUrl']),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStateColumn(postLen,'posts',),
                              buildStateColumn(followers,'followers',),
                              buildStateColumn(following,'following',),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                             FirebaseAuth.instance.currentUser!.uid==widget.uid?
                             FollowButton(
                                text: 'Sign Out',
                                backgroundcolor: mobileBackgroundColor,
                                textColor: primaryColor,
                                borderColor: Colors.grey,
                                function: ()async{
                                  await AuthMethods().signOut();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context)=>LoginScreen()));
                                },
                              ): isFollowing? FollowButton(
                               text: 'Unfollow',
                               backgroundcolor: Colors.white,
                               textColor: Colors.black,
                               borderColor: Colors.grey,
                               function: ()async{
                                 await FireStoreMethods()
                                     .followUser(
                                     FirebaseAuth.instance.currentUser!.uid,
                                     userData['uid']
                                 );
                                 setState(() {
                                   isFollowing=false;
                                   followers--;
                                 });
                               },
                             ):FollowButton(
                               text: 'Follow',
                               backgroundcolor: Colors.blue,
                               textColor: Colors.white,
                               borderColor: Colors.blue,
                               function: ()async{
                                   await FireStoreMethods()
                                       .followUser(
                                       FirebaseAuth.instance.currentUser!.uid,
                                       userData['uid']
                                   );

                                   setState(() {
                                     isFollowing=true;
                                     followers++;
                                   });
                               },
                             )
                            ],
                          ),
                        ],
                      ),

                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 15),
                  child: Text(userData['username'],style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 5,),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 1),
                  child: Text(userData['bio']),
                ),
              ],
            ),
          ),
          Divider(),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('uid',isEqualTo: widget.uid).get(),
              builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }
              return GridView.builder(
                shrinkWrap: true,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1
                  ),
                  itemBuilder: (context,index){
                  DocumentSnapshot snap=(snapshot.data! as dynamic).docs[index];
                  return Container(
                    child: Image(
                      image: NetworkImage(
                          snap['postUrl']
                      ),
                      fit: BoxFit.cover,
                    ),
                  );
                  }
              );
              })
        ],
      ),
    );
  }
  Column buildStateColumn(int num,String label){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(num.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(label,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.grey),)),
      ],
    );
  }
}
