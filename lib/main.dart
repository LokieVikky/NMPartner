import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:partner/Screens/FormPage/form.dart';
import 'package:partner/Screens/FormPage/shopInfo.dart';
import 'package:partner/Screens/HomePages/homePage.dart';
import 'package:partner/Screens/LoginPage/loginPage.dart';
import 'package:partner/Screens/OrderPages/orderConfirm.dart';
import 'package:partner/Screens/OrderPages/orderPage.dart';
import 'package:partner/Screens/ProfilePages/addNewEmployee.dart';
import 'package:partner/Screens/ProfilePages/editEmployee.dart';
import 'package:partner/Screens/ProfilePages/editServices.dart';
import 'package:partner/Screens/ProfilePages/widgets/allReviews.dart';
import 'package:partner/provider/mProvider/currentStepProvider.dart';
import 'package:partner/screens/LoginPage/Verification.dart';
import 'package:partner/services/apiService.dart';

void main() async {
  var home;
  WidgetsFlutterBinding.ensureInitialized();
  var apiToken = await ApiService().readAccessToken();

  if(apiToken == null || apiToken.isEmpty) {
    home = LoginPage();
  } else {
    String? partnerId = await ApiService().readPartnerId();
    if(partnerId != null) {
      var currentStep = await ApiService().getCurrentStep(partnerId);
      if(currentStep < 3) {
        home = FormPage();
      } else {
        home = HomePage();
      }
    }
  }
  runApp(ProviderScope(child: MyApp(home)));
}

class MyApp extends StatelessWidget {
  dynamic mHome;

  MyApp(this.mHome);

  @override
  Widget build(BuildContext context) {
    // todo CodeChanged
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/verify': (context) => Verification('', ''),
        '/form': (context) => FormPage(),
        '/homePage': (context) => HomePage(),
        '/orderPage': (context) => OrderPage(),
        '/orderConfirm': (context) => OrderConfirm(),
        '/editEmployee': (context) => EditEmployee(),
        '/addNewEmployee': (context) => AddNewEmployee(),
        '/editServices': (context) => EditServices(),
        '/shopInfo' : (context) => ShopInfo(),
        '/reviewScreen' : (context) => AllRevivews([])
      },
      home: mHome,
    );
  }
}