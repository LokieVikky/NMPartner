import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:partner/provider/providers.dart';
import 'package:partner/screens/LoginPage/Verification.dart';
import 'package:partner/services/apiService.dart';
import 'package:partner/shared/custom_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform, name: 'auth');
  await CountryCodes.init();
  runApp(ProviderScope(child: MechanicsPartner()));
}

class MechanicsPartner extends ConsumerStatefulWidget {
  @override
  ConsumerState<MechanicsPartner> createState() => _MechanicsPartnerState();
}

class _MechanicsPartnerState extends ConsumerState<MechanicsPartner> {
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
      home: Material(
        child: AuthWidget(
          signedInBuilder: (context) {
            return ref.watch(registrationStatusProvider).when(
              data: (int? data) {
                if (data == null) {
                  return AppErrorWidget();
                }
                if (data < 3) {
                  return FormPage();
                } else {
                  return HomePage();
                }
              },
              error: (error, stackTrace) {
                return AppErrorWidget(errorText: error.toString(),);
              },
              loading: () {
                return CupertinoActivityIndicator();
              },
            );
          },
          nonSignedInBuilder: (BuildContext context) {
            return const SignInPage();
          },
        ),
      ),
    );
  }
}
