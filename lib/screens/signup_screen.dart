import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intstagram2/resources/auth_methods.dart';
import 'package:intstagram2/screens/login_screen.dart';
import 'package:intstagram2/utils/colors.dart';
import 'package:intstagram2/utils/utils.dart';
import 'package:intstagram2/widget/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({Key? key}) : super(key: key);

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {

  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  final TextEditingController _bioController=TextEditingController();
  final TextEditingController _usernameController=TextEditingController();
  Uint8List? _image;
  bool _isLoading=false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }
  void selectimage() async{
    Uint8List im=await pickImage(ImageSource.gallery);
    setState(() {
      _image=im;
    });
  }
  void signUpUser() async {
    setState(() {
      _isLoading=true;
    });
    String res=await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!,
    );

    if(res =='success'){
      setState(() {
      _isLoading=false;});

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context)=>
          ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
          )));

    }else{
      setState(() {
        _isLoading=false;});
      showSnackBar(res, context);
    }
  }
  void navigateToLogin(){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=>LoginScreen()
         ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex: 2,),
              // svg image
              SvgPicture.asset('assets/ic_instagram.svg',color: primaryColor,height: 64,),
              SizedBox(height: 64,),
              // circular widget to accept and show our selected file
              Stack(
                children: [
                  _image!=null?
              CircleAvatar(
              radius: 64,
                backgroundImage: MemoryImage(_image!),
              )
                  :CircleAvatar(
                    radius: 64,
                   backgroundImage: NetworkImage('https://thumbs.dreamstime.com/b/default-profile-picture-avatar-photo-placeholder-vector-illustration-default-profile-picture-avatar-photo-placeholder-vector-189495158.jpg'),
                  ),
                  Positioned(
                    bottom: -10,
                      left: 80,
                      child: IconButton(
                    onPressed: selectimage,
                    icon: Icon(Icons.add_a_photo),
                  ))
                ],
              ),
              SizedBox(height: 24,),
              //text field input for username
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
              ),
              SizedBox(height: 24,),
              //text field input for email
              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24,),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              SizedBox(height: 24,),
              TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,

              ),
              SizedBox(height: 24,),
              // button login
              InkWell(

                child: Container(
                  child: !_isLoading ?Text('Sign up')
                   :Center(
                  child: CircularProgressIndicator(color: primaryColor,),),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))
                      ),
                    color: blueColor,
                  ),
                ),onTap: signUpUser,
              ),
              SizedBox(height: 12,),
              Flexible(child: Container(),flex: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account"),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap:navigateToLogin,
                    child: Container(
                      child: Text("Login", style: TextStyle(fontWeight:FontWeight.bold),),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
