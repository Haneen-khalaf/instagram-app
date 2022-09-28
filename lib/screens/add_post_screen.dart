import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intstagram2/providers/user_provider.dart';
import 'package:intstagram2/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}
class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController=TextEditingController();
  bool _isLoading=false;

  void postImage(
    String uid,
  String username,
  String profImage,
  )async{
    setState(() {
      _isLoading=true;
    });
    try{
     String res=await FireStoreMethods().uploadPost(
         _descriptionController.text,
         _file!,
         uid,
         username,
         profImage);

     if(res=='success'){
       setState(() {
         _isLoading=false;
       });
       showSnackBar('Posted', context);
       clearImage();
     }else{
       setState(() {
         _isLoading=false;
       });
       showSnackBar(res, context);
     }
    }catch(e){
    showSnackBar(e.toString(), context);
    }

  }

  _selectImage(BuildContext context)async{
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: Text('Create a post'),
        children: [
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text('Take a photo'),
            onPressed: ()async{
              Navigator.of(context).pop();
              Uint8List file= await pickImage(ImageSource.camera);
              setState(() {
                _file=file;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text('choose from gallery'),
            onPressed: ()async{
              Navigator.of(context).pop();
              Uint8List file= await pickImage(ImageSource.gallery);
              setState(() {
                _file=file;
              });
            },
          ),
          SimpleDialogOption(
            padding: EdgeInsets.all(20),
            child: Text('Cancle'),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
  void  clearImage(){
    setState(() {
      _file=null;
    });
  }
  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final User? user=Provider.of<UserProvider>(context).getUser;

    return _file==null?Center(
      child: IconButton(
        icon: Icon(Icons.upload),
        onPressed: ()=> _selectImage(context),
      ),
    ):
     Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: Text('Post to'),
        actions: [
          TextButton(onPressed: ()=>postImage(
              user!.uid,
              user!.username,
              user!.photoUrl),
              child: Text('Post',style: TextStyle(
              color: Colors.blueAccent,
             fontWeight: FontWeight.bold,
            fontSize: 16,
          ),),),
        ],
      ),
      body: Column(
        children: [
          _isLoading?LinearProgressIndicator()
          :Padding(padding: EdgeInsets.only(top:0)),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.45,
              child:TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'write a caption...',
                  border: InputBorder.none,
                ),
                maxLines: 8,
              ),
              ),
              SizedBox(
                height: 45,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Divider()
            ],
          )
        ],
      ),
    );
  }
}