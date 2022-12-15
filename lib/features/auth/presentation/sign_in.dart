import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:partner/features/auth/presentation/send_otp_controller.dart';
import 'package:partner/features/auth/presentation/verify_otp_controller.dart';
import 'package:partner/shared/assets.dart';
import 'package:partner/shared/async_value_ui.dart';
import 'package:partner/shared/country_codes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../shared/country_code_selector_page.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage>
    with TickerProviderStateMixin {
  FocusNode otpFocusNode = FocusNode();
  bool isCodeSent = false;

  Map<String, String> countryDetails =
      AppCountryCodes.getCurrentCountryDetails();

  String verificationId = '';
  TextEditingController mobileNumberController = TextEditingController();

  final FocusNode _nodeText3 = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText3,
          onTapAction: () {
            ref.read(sendOTPControllerProvider.notifier).sendOTP(
                mobileNumber:
                    countryDetails['dial_code']! + mobileNumberController.text);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isCodeSent) {
      otpFocusNode.requestFocus();
    }
    ref.listen<AsyncValue>(sendOTPControllerProvider,
        (previous, AsyncValue state) {
      state.showSnackBarOnError(context);
    });

    ref.listen<AsyncValue>(verifyOTPControllerProvider,
        (previous, AsyncValue state) {
      state.showSnackBarOnError(context);
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Center(
                            child: Image.asset(appAssets.logoNammaMechanics))),
                    Text(
                      'Register your shop in Namma Mechanics and get the right customers in front of your shop.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffADADAD),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMobileNumberField(),
                    Visibility(
                      visible: isCodeSent,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _buildOTPField(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeadingText() {
    return Text(
      'Namma Mechanics',
      style: TextStyle(fontSize: 45),
    );
  }

  Widget _buildFriendsDecorationV2() {
    return Image.asset(appAssets.logoNammaMechanics);
  }

  Widget _buildMobileNumberField() {
    Widget mobileNumberField = TextFormField(
      controller: mobileNumberController,
      focusNode: _nodeText3,
      maxLength: 12,
      keyboardType: TextInputType.number,
      onChanged: (_) {
        if (isCodeSent) {
          ref.read(sendOTPControllerProvider.notifier).clearVerificationId();
          setState(() {});
        }
      },
      onFieldSubmitted: (String val) {
        ref
            .read(sendOTPControllerProvider.notifier)
            .sendOTP(mobileNumber: countryDetails['dial_code']! + val);
      },
      decoration: InputDecoration(
        hintText: 'Enter your mobile number',
        counterText: '',
        border: const OutlineInputBorder(),
        prefixIcon: IconButton(
          icon: Text(
            countryDetails['flag']!,
            style: const TextStyle(fontSize: 20),
          ),
          onPressed: () async {
            var result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CountryCodeSelectorPage(),
            ));
            if (result != null) {
              setState(() {
                countryDetails = result;
              });
            }
          },
        ),
        suffixIcon: ref.watch(sendOTPControllerProvider).when(
          data: (String data) {
            isCodeSent = data.isNotEmpty;
            if (data.isNotEmpty) {
              otpFocusNode.requestFocus();
              setState(() {
                verificationId = data;
              });
            }
            return const Icon(Icons.abc, size: 0);
          },
          error: (error, stackTrace) {
            return const Icon(Icons.abc, size: 0);
          },
          loading: () {
            return const CupertinoActivityIndicator();
          },
        ),
      ),
    );
    if (Platform.isIOS) {
      return KeyboardActions(
        tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
        autoScroll: false,
        config: _buildConfig(context),
        child: mobileNumberField,
      );
    }
    return mobileNumberField;
  }

  Widget _buildOTPField() {
    return PinCodeTextField(
      focusNode: otpFocusNode,
      appContext: context,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.go,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(4),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.grey,
        inactiveColor: Colors.grey,
        borderWidth: 1,
      ),
      length: 6,
      onChanged: (otp) async {
        if (otp.length == 6) {
          await ref
              .read(verifyOTPControllerProvider.notifier)
              .sendOTP(verificationId: verificationId, otp: otp);
        }
      },
    );
  }
}
