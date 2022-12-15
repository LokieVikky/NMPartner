import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:partner/features/auth/presentation/auth_widget.dart';
import 'package:partner/features/auth/presentation/sign_in.dart';
import 'package:partner/firebase_options.dart';
import 'package:partner/provider/mProvider/currentStepProvider.dart';
import 'package:partner/screens/LoginPage/Verification.dart';
import 'package:partner/services/apiService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: 'auth');
  await CountryCodes.init();
  runApp(ProviderScope(child: MechanicsPartner()));
}

class MechanicsPartner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        '/shopInfo': (context) => ShopInfo(),
        '/reviewScreen': (context) => AllRevivews([])
      },
      home: AuthWidget(
        signedInBuilder: (context) {
          return FutureBuilder<Widget>(
            future: getCurrentStep(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data ?? Container();
              }
              return CircularProgressIndicator();
            },
          );
        },
        nonSignedInBuilder: (BuildContext context) {
          return const SignInPage();
        },
      ),
    );
  }

  Future<Widget> getCurrentStep() async {
    String? partnerId = FirebaseAuth.instance.currentUser?.uid;
    var currentStep = await ApiService().getCurrentStep(partnerId);
    if (currentStep < 3) {
      return FormPage();
    } else {
      return HomePage();
    }
  }
}
