import 'package:blogger_flutter/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'package:provider/provider.dart';
import 'model/blogModel.dart';
import 'constants.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
//import 'package:flutter/services.dart';


void main() {
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
  if(!kIsWeb){
  Admob.initialize(kAdmobAppId);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BlogModelNotifier>(
      create: (_) => BlogModelNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: kAppTitle,
        theme: ThemeData(
          primarySwatch: kAppColor,
          fontFamily: 'Raleway',
          scaffoldBackgroundColor: Colors.grey.shade100,
        ),
        // initialRoute: HomePage.id,
        initialRoute: '/splash',
        routes: {
          HomePage.id: (_) => HomePage(),
          '/splash': (context) => SplashScreen(),
        },
      ),
    );
  }
}
