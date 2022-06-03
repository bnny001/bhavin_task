import 'package:bhavin/screens/home_screen.dart';
import 'package:bhavin/screens/registeration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  
   TextEditingController emailController = new TextEditingController();

 TextEditingController passwordController = new TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // color: Colors.red,
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextFormField(
                      controller: emailController,
                        decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Email',
                    )),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                    child: TextFormField(
                      controller: passwordController,
                        decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Password',
                    )),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.green,
                        onPressed: () async {
                          if(emailController.text != '' && passwordController.text != ''){
                            await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text)
                              .then((value) {
                            if (value.user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => HomeScreen()),
                              );
                            }
                          });
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.green)),
                      ),
                    )),


                     SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Don't have an acount?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterationPage()),
                        );
                      },
                      child: Text("Register"))
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}