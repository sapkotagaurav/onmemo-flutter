import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onmemo/rootpage.dart';

import 'Services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OnMemo',
        debugShowCheckedModeBanner: false,
        home: RootPage(
          auth: Auth(),
        ));
  }
}

class OnMemo extends StatefulWidget {
  OnMemo(this.auth, this.logincallback);

  VoidCallback logincallback;
  BaseAuth auth;

  @override
  _OnMemoState createState() => _OnMemoState();
}

class _OnMemoState extends State<OnMemo> {
  TextStyle comfortaa = GoogleFonts.comfortaa();
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  final focusnode = FocusNode();
  final mauth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (AppBar(
          title: Row(
            children: <Widget>[
              ImageIcon(AssetImage("assets/profile.png")),
              Text(
                "OnMemo Login",
                style: comfortaa,
              )
            ],
          ),
        )),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Login Using Email and Password:",
                      style: comfortaa,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      autovalidate: true,
                      child: TextFormField(
                        controller: EmailController,
                        style: comfortaa,
                        onFieldSubmitted: (arg) {
                          FocusScope.of(context).requestFocus(focusnode);
                        },
                        decoration: InputDecoration(
                            labelText: "Email", hintText: "example@gmail.com"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      autovalidate: true,
                      child: TextFormField(
                        obscureText: true,
                        controller: PasswordController,
                        style: comfortaa,
                        focusNode: focusnode,
                        decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "6 Characters long"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      color: Colors.primaries[5],
                      child: Text("Submit"),
                      onPressed: () async {
                        try {
                          String userid = await widget.auth.signIn(
                              EmailController.text, PasswordController.text);
                          print(userid);
                          if (userid != null && userid != "") {
                            setState(() {
                              widget.logincallback();
                            });
                          }
                        } catch (e) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                          ));
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Or",
                      style: comfortaa,
                    ),
                    SignInButton(
                      Buttons.GoogleDark,
                      onPressed: () async {
                        String userid = await widget.auth.signinwithgoogle();
                        print(userid);
                        setState(() {
                          widget.logincallback();
                        });
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                        "Felt Too Lazy to add sign up and forgot password here. Go to web version, I know you're lazy as well. Sign in with google instead.",
                        softWrap: true,
                        style: GoogleFonts.athiti())
                  ],
                ),
              ),
            );
          },
        ));
  }
}
