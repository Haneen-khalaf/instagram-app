import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intstagram2/providers/user_provider.dart';
import 'package:intstagram2/responsive/mobile_screen_layout.dart';
import 'package:intstagram2/responsive/responsive_layout_screen.dart';
import 'package:intstagram2/responsive/web_screen_layout.dart';
import 'package:intstagram2/screens/login_screen.dart';
import 'package:intstagram2/screens/signup_screen.dart';
import 'package:intstagram2/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyBlFZFaOR5vd6Sk1HX2u7VOA4dgr91HAx4',
          appId: '1:940848525145:web:8d3c41e7aab28a9c726648',
          messagingSenderId: '940848525145',
          projectId: 'instagram-tut-fa6f8',
      storageBucket: 'instagram-tut-fa6f8.appspot.com'
      ),
    );
  }else{
    await Firebase.initializeApp();
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        //home:ResponsiveLayout(mobileScreenLayout:MobileScreenLayout() ,webScreenLayout:WebScreenLayout() ,),
        home: StreamBuilder(
          builder:(context,snapshot) {
            if(snapshot.connectionState==ConnectionState.active){
              if(snapshot.hasData){
                return ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout());
              }else if(snapshot.hasError){
                return Center(child: Text('${snapshot.error}'),);
              }
            }
            if(snapshot.connectionState== ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(color: primaryColor,),
              );
            }
            return LoginScreen();
          },
          stream: FirebaseAuth.instance.authStateChanges(),
        ),
      ),
    );
  }
}

