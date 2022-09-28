import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intstagram2/screens/feed_screen.dart';
import 'package:intstagram2/screens/profile_screen.dart';
import 'package:intstagram2/screens/search_screen.dart';

import '../screens/add_post_screen.dart';

const webScreenSize=600;

List<Widget> homeScreenItems=[
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('notifications'),
  ProfileScreen(uid:FirebaseAuth.instance.currentUser!.uid
  ),
];

