import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onlinre_polling/core/authentication/firebase_auth.dart';
import 'package:onlinre_polling/core/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onlinre_polling/core/widgets/loading-animation.dart';
import 'package:onlinre_polling/screens/01-dashboard/dashboard.dart';

class HomePage extends StatefulWidget {
  static const String id = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _content;
  bool _showLoading;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();

  @override
  void initState() {
    _content = buildWelcomeContent();
    _showLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background.blueGrey,
      body: Stack(
        children: [
          ///Background Pattern
          SvgPicture.asset(
            AppImages.background.homePatterns,
            semanticsLabel: 'home-bg',
          ),

          ///Content
          Center(
            child: Container(
              width: 900,
              height: 600,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.28999999165534973),
                      offset: Offset(3, 4),
                      blurRadius: 30)
                ],
                color: AppColor.background.blueGreen,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      AppImages.illustrations.boySearch,
                      semanticsLabel: 'boy-searching',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: _content,
                    ),
                  ),
                ],
              ),
            ),
          ),

          ///Loading animation
          if (_showLoading) LoadingAnimation(),
        ],
      ),
    );
  }

  Widget buildWelcomeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Team - 1
        Container(
          padding: EdgeInsets.only(left: 30, top: 30),
          child: Text(
            '- Team 1',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Color.fromRGBO(255, 132, 0, 1),
                  fontSize: 14,
                  letterSpacing: 0.3959999978542328,
                  fontWeight: FontWeight.bold,
                  height: 0.6428571428571429),
            ),
          ),
        ),

        ///Title
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Text(
            'Online Polling / Feedback System',
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 35,
                  letterSpacing: 0.3959999978542328,
                  fontWeight: FontWeight.bold,
                  height: 1.212962962962963),
            ),
          ),
        ),

        ///Description
        Container(
          margin: EdgeInsets.only(left: 30, bottom: 20, right: 30),
          child: Text(
            'Login to your  account and select the event then vote for the team or parties or an individual person 😊',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: AppColor.text.grey,
                fontSize: 14,
                letterSpacing: 0.3959999978542328,
                fontWeight: FontWeight.normal,
                height: 1.75,
              ),
            ),
          ),
        ),

        ///Sub title
        Container(
          padding: EdgeInsets.only(top: 40, bottom: 10, left: 30, right: 30),
          child: Center(
            child: RichText(
              text: TextSpan(
                text: 'Your thoughts. ',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 26,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      height: 1.0769230769230769),
                ),
                children: const <TextSpan>[
                  TextSpan(
                    text: 'Cleaner',
                    style: TextStyle(
                      color: Color.fromRGBO(67, 223, 168, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        ///Sub title 2
        Container(
          padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
          child: Center(
            child: Text(
              'Bring clarity to your thoughts',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: 18,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w200,
                  height: 1.1111111111111112,
                ),
              ),
            ),
          ),
        ),

        Expanded(
          child: SizedBox(),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ///login
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 5,
                  left: 30,
                  right: 30,
                ),
                child: CustomButton(
                  text: 'Login',
                  onTap: () {
                    changeContent(Content.loginContent);
                  },
                ),
              ),
            ),

            ///signup
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                child: CustomButton(
                  textColor: Colors.black,
                  bgColor: AppColor.white,
                  text: 'Signup',
                  onTap: () {
                    changeContent(Content.signupContent);
                  },
                ),
              ),
            ),

            ///request a poll
            Center(
              child: Text(
                'Request a Poll',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 12,
                    letterSpacing: 0,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ],
    );
  }

  Widget buildLoginContent() {
    return Column(
      children: [
        ///Email
        Container(
          width: 300,
          padding: EdgeInsets.only(top: 200),
          child: TextField(
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),

        ///Passwo
        Container(
          width: 300,
          padding: EdgeInsets.only(top: 50),
          child: TextField(
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            obscureText: true,
            obscuringCharacter: '*',
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),

        ///login
        Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: 100,
              bottom: 5,
              left: 30,
              right: 30,
            ),
            child: CustomButton(
              text: 'Login',
              onTap: () {
                login();
              },
            ),
          ),
        ),

        ///Cancel
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
            child: CustomButton(
              textColor: Colors.black,
              bgColor: AppColor.white,
              text: 'Cancel',
              onTap: () {
                changeContent(Content.welcomeContent);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSignupContent() {
    return Column(
      children: [
        ///Email
        Container(
          width: 300,
          padding: EdgeInsets.only(top: 100),
          child: TextField(
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),

        ///Password
        Container(
          width: 300,
          padding: EdgeInsets.only(top: 50),
          child: TextField(
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            obscureText: true,
            obscuringCharacter: '*',
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),

        ///Confirm Password
        Container(
          width: 300,
          padding: EdgeInsets.only(top: 50),
          child: TextField(
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            obscureText: true,
            obscuringCharacter: '*',
            controller: conformPasswordController,
            decoration: InputDecoration(
              hintText: 'Conform Password',
              hintStyle: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),

        ///Signup
        Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: 100,
              bottom: 5,
              left: 30,
              right: 30,
            ),
            child: CustomButton(
              text: 'Signup',
              onTap: () {
                signup();
              },
            ),
          ),
        ),

        ///Cancel
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
            child: CustomButton(
              textColor: Colors.black,
              bgColor: AppColor.white,
              text: 'Cancel',
              onTap: () {
                changeContent(Content.welcomeContent);
              },
            ),
          ),
        ),
      ],
    );
  }

  void login() async {
    setState(() {
      _showLoading = true;
    });
    var status;
    if (emailController.text == 'admin' &&
        passwordController.text == 'admin@123') {
      status = await FirebaseAuthentication.signInWithEmailPassword(
          'admin@gmail.com', 'admin@123');
      isAdmin = true;
    } else {
      status = await FirebaseAuthentication.signInWithEmailPassword(
          emailController.text, passwordController.text);
      isAdmin = false;
    }
    if (status == true) Navigator.pushNamed(context, DashboardPage.id);
    setState(() {
      _showLoading = false;
    });
  }

  void signup() async {
    setState(() {
      _showLoading = true;
    });
    var status = await FirebaseAuthentication.registerWithEmailPassword(
        emailController.text, passwordController.text);
    if (status == true) Navigator.pushNamed(context, DashboardPage.id);
    setState(() {
      _showLoading = false;
    });
  }

  void changeContent(int content) {
    setState(() {
      switch (content) {
        case 1:
          {
            _content = buildWelcomeContent();
            break;
          }
        case 2:
          {
            _content = buildLoginContent();
            break;
          }
        case 3:
          {
            _content = buildSignupContent();
            break;
          }
      }
    });
  }
}

class Content {
  static int welcomeContent = 1;
  static int loginContent = 2;
  static int signupContent = 3;
  static int requestPollContent = 4;
}

class CustomButton extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final String text;
  final Function onTap;

  CustomButton({
    this.bgColor = const Color.fromRGBO(0, 22, 10, 1),
    this.textColor = const Color.fromRGBO(255, 255, 255, 1),
    @required this.text,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Tapped');
        onTap();
      },
      child: Container(
        width: 211,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          color: bgColor,
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                  height: 1),
            ),
          ),
        ),
      ),
    );
  }
}
