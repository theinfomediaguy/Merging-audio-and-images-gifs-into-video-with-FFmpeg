/*
import 'package:flutter/material.dart';
import 'package:image_music/common/color_palette.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Sign in"),
        centerTitle: true,
      ),
      body: Consumer<LoginProvider>(
        builder: (context, prov, _) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 30,
              height: MediaQuery.of(context).size.height - 530,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () async {

                    },
                    child: Text('Login',
                        style: TextStyle(color: Palette.tertiary)),
                    color: Palette.primary,
                    splashColor: Palette.secondary,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/
