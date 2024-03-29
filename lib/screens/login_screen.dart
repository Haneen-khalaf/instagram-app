import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intstagram2/resources/auth_methods.dart';
import 'package:intstagram2/screens/signup_screen.dart';
import 'package:intstagram2/utils/colors.dart';
import 'package:intstagram2/utils/global_variables.dart';
import 'package:intstagram2/utils/utils.dart';
import 'package:intstagram2/widget/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  bool _isLoading =false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  void loginUser()async{
    setState(() {
      _isLoading= true;
    });
    String res=await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text);
  if(res=='success'){
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context)=>
        ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
           )),
        (route)=>false
    );
    setState(() {
      _isLoading=false;
    });
    }else{
    setState(() {
      _isLoading= false;
    });
    showSnackBar(res, context);
  }
  }
  void navigateToSignup(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width>webScreenSize
              ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3)
              :EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(),flex: 2,),
              // svg image
              SvgPicture.asset('assets/ic_instagram.svg',color: primaryColor,height: 64,),
              SizedBox(height: 64,),
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
              // button login
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: !_isLoading
                      ?Text('Log in')
                      : Center(child: CircularProgressIndicator(color: primaryColor,),
                  ),

        width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              SizedBox(height: 12,),
              Flexible(child: Container(),flex: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("Don't have an account?"),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      child: Text("Sign up", style: TextStyle(fontWeight:FontWeight.bold),),
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
