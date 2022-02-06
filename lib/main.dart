import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:partner/Screens/FormPage/formPage.dart';
import 'package:partner/Screens/HomePages/homePage.dart';
import 'package:partner/Screens/LoginPage/loginPage.dart';
import 'package:partner/Screens/OrderPages/orderConfirm.dart';
import 'package:partner/Screens/OrderPages/orderPage.dart';
import 'package:partner/Screens/ProfilePages/addNewEmployee.dart';
import 'package:partner/Screens/ProfilePages/editEmployee.dart';
import 'package:partner/Screens/ProfilePages/editServices.dart';
import 'package:partner/Screens/ProfilePages/providers/ProfilePageProvider.dart';
import 'package:partner/connectChecker.dart';
import 'package:partner/provider/currentState.dart';
import 'package:partner/provider/form_provider.dart';
import 'package:partner/provider/orderProvider.dart';
import 'package:partner/screens/LoginPage/Verification.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //StreamProvider.value(),
        StreamProvider<ConnectionResult>.value(
          value: CheckConnectionStatus().connectionChecker.stream,
        ),

        ChangeNotifierProvider(create: (context) => CurrentState()),
        ChangeNotifierProvider(create: (context) => FormProvider()),
        ChangeNotifierProvider(create: (context) => orderProvider()),
        ChangeNotifierProvider(create: (context) => ProfilePageProvider()),
        ChangeNotifierProxyProvider<CurrentState, orderProvider>(
            create: (R) => orderProvider(),
            update: (_, currentState, data) =>
                data..login(currentState.prefs.getString('loginID'))),
        ChangeNotifierProxyProvider<CurrentState, ProfilePageProvider>(
            create: (R) => ProfilePageProvider(),
            update: (_, currentState, data) =>
                data..login(currentState.prefs.getString('loginID'))),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => LoginPage(),
          '/verify': (context) => Verification('', ''),
          '/formPage': (context) => FormPage(),
          '/homePage': (context) => HomePage(),
          '/orderPage': (context) => OrderPage(),
          '/orderConfirm': (context) => OrderConfirm(),
          '/editEmployee': (context) => EditEmployee(),
          '/addNewEmployee': (context) => AddNewEmployee(),
          '/editServices': (context) => EditServices(),
        },
        home: LoginPage(),
      ),
    );
  }
}
