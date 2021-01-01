import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_skeleton/crudScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

User user;
var userName = '';
// Firebase and Google Sign In Initialization
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
GoogleSignIn googleSignIn = GoogleSignIn();

class FirebaseSkeleton extends StatelessWidget {
  const FirebaseSkeleton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CrudScreen()));
        },
        label: Text('Go To CRUD Screen'),
        icon: Icon(Icons.construction),
      ),
      appBar: AppBar(
        title: Text('Firebase Skeleton'),
        centerTitle: true,
      ),
      body: SkeletonBody(),
    );
  }
}

class SkeletonBody extends StatefulWidget {
  @override
  _SkeletonBodyState createState() => _SkeletonBodyState();
}

class _SkeletonBodyState extends State<SkeletonBody> {
  // For Sign in and Sign Up
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Text('Currently User Logged In : $userName')),

        // Login With Input
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              InputForm(
                controller: emailController,
                labelText: 'Enter Email',
                icon: Icons.email,
                textInputType: TextInputType.emailAddress,
              ),
              smallGapHere,
              InputForm(
                controller: passController,
                labelText: 'Enter password',
                icon: Icons.vpn_key,
                obscureText: true,
                textInputType: TextInputType.visiblePassword,
              ),
              smallGapHere,
              // Sign Up and Sign in Using Email
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    onPressed: () async {
                      user = await firebaseAuth
                          .createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passController.text)
                          .then((value) => value.user);
                    },
                    child: Text('Sign Up'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    onPressed: () async {
                      user = (await firebaseAuth.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passController.text))
                          .user;
                      setState(() {
                        userName = user.email;
                      });
                    },
                    child: Text('Sign In'),
                  ),
                ],
              ),
            ],
          ),
        ),
        /* --------------------->
          Sign In With Google
          ----------------------->
        */
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: () async {
            GoogleSignInAccount googleUser = await googleSignIn.signIn();
            GoogleSignInAuthentication googleAuth =
                await googleUser.authentication;

            AuthCredential authCredential = GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken);

            user =
                (await firebaseAuth.signInWithCredential(authCredential)).user;
            setState(() {
              userName = user.email;
            });
          },
          child: Text('Sign In With Google'),
        ),
      ],
    );
  }
}

/* <-------------------
Styling And other Things, these things are unrelated for this
-------------------> */

var smallGapHere = SizedBox(
  height: 20,
);

class InputForm extends StatelessWidget {
  const InputForm({
    Key key,
    @required this.controller,
    this.labelText,
    this.obscureText = false,
    this.icon,
    this.textInputType,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final IconData icon;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: labelText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.lightBlueAccent,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 3,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
