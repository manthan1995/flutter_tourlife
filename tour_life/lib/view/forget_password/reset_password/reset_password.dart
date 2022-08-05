import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:tour_life/constant/colorses.dart';
import 'package:tour_life/constant/strings.dart';
import 'package:tour_life/view/forget_password/reset_password/set_password/set_password_screen.dart';

import '../../../constant/images.dart';
import '../../../widget/commanBtn.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colorses.black,
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 40, child: Image.asset(Images.splashLogoImage)),
              Column(
                children: [
                  Text(
                    Strings.verificationStr,
                    style: TextStyle(
                        color: Colorses.white,
                        fontSize: 35,
                        fontFamily: 'Inter-Medium'),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: Strings.verificationSubStr,
                      style: TextStyle(
                          color: Colorses.white,
                          fontSize: 14,
                          fontFamily: 'Inter-Medium'),
                      children: <TextSpan>[
                        TextSpan(
                            text: Strings.tourLifeEmailStr,
                            style: TextStyle(color: Colorses.red)),
                      ],
                    ),
                  )
                ],
              ),
              OtpTextField(
                borderRadius: BorderRadius.circular(20),
                fieldWidth: 55,
                textStyle: TextStyle(color: Colorses.white),
                disabledBorderColor: Colorses.red,
                focusedBorderColor: Colorses.red,
                enabledBorderColor: Colorses.white,
                numberOfFields: 4,
                borderColor: Colorses.red,
                showFieldAsBox: true,
                onCodeChanged: (String code) {},
                onSubmit: (String verificationCode) {
                  // showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return AlertDialog(
                  //         title: const Text("Verification Code"),
                  //         content: Text('Code entered is $verificationCode'),
                  //       );
                  //     });
                },
              ),
              Column(
                children: [
                  CommanBtn(
                    text: Strings.submitOtpStr,
                    bgColor: Colorses.red,
                    txtColor: Colorses.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SetPassScreen()),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: Strings.reSendOtpStr,
                      style: TextStyle(
                          color: Colorses.white,
                          fontSize: 14,
                          fontFamily: 'Inter-Medium'),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' 0:20',
                            style: TextStyle(color: Colorses.red)),
                      ],
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
