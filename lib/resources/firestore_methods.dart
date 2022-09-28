import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intstagram2/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import '../models/Post.dart';

class FireStoreMethods{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  //upload post

Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
    )async{
  String res='some error occurred';
  try{
    String photoUrl=await StorageMethods().uploadImageToStorage('posts', file, true);
     String postId=Uuid().v1();
    Post post=Post(
      description: description,
      uid: uid,
      username: username,
      postId: postId,
      datePublished: DateTime.now(),
      postUrl: photoUrl,
      profImage: profImage,
      likes: []
    );
    _firestore.collection('posts').doc(postId).set(post.toJson());
    res='success';

  }catch(err){
     res=err.toString();
  }
  return res;
}
Future<String> likePost(String postId,String uid,List likes)async{
  String res='some error occurred';
  try{
    if(likes.contains(uid)){
     await _firestore.collection('posts').doc(postId).update({
        'likes':FieldValue.arrayRemove([uid]),
      });
    }else{
      await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayUnion([uid]),
        });
    }
    res='success';
  }catch(e){
    res=e.toString();
  }
  return res;
}
  Future<String> postComment(String postId,String text,String uid,String name,String profilePic)async{
    String res='some error occurred';
  try{
      if(text.isNotEmpty){
        String commentId=Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic':profilePic,
          'name':name,
          'uid':uid,
          'text':text,
          'commentId':commentId,
          'datePublished':DateTime.now(),
        });
        res='success';
      }else{
        res='please enter text';
      }
    }catch(e){
     res=e.toString();
    }
    return res;
}
   //deleting the post
Future<String> deletePost(String postId)async{
  String res='some error occurred';
  try{
   await _firestore.collection('posts').doc(postId).delete();
  }catch(err){
    res = err.toString();
  }
  return res;
}
Future <void> followUser(
    String uid,
    String followId,
    )async{
  try{
    DocumentSnapshot snap= await _firestore.collection('users').doc(uid).get();
    List following=(snap.data()! as dynamic)['following'];

    if(following.contains(followId)){
      await _firestore.collection('users').doc(followId).update({
    'followers':FieldValue.arrayRemove([uid])
  });
      await _firestore.collection('users').doc(uid).update({
        'following':FieldValue.arrayRemove([followId])
      });

  }else{
      await _firestore.collection('users').doc(followId).update({
        'followers':FieldValue.arrayUnion([uid])
      });
      await _firestore.collection('users').doc(uid).update({
        'following':FieldValue.arrayUnion([followId])
      });
    }
  }catch(e){
    print(e.toString());
  }
}
}