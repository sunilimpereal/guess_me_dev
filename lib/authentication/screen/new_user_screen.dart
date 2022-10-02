import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guessme/authentication/bloc/login_bloc.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/authentication/screen/loginscreen.dart';
import 'package:guessme/authentication/screen/widgets/textfield.dart';
import 'package:guessme/home/screens/homescreen.dart';

import '../data/repository/authrepository.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  TextEditingController userNameController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showLoading = false;
  @override
  Widget build(BuildContext context) {
    LoginBloc? loginBloc = LoginProvider.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          username(loginBloc!),
        ],
      ),
    );
  }

  Widget username(LoginBloc loginBloc) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Enter Username",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Textfield(
                controller: userNameController,
                stream: loginBloc.username,
                label: "username",
                onChanged: loginBloc.changeUsername,
                inputType: TextInputType.name,
              )
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              setState(() {
                showLoading = true;
              });
              await _auth.currentUser
                  ?.updateDisplayName(userNameController.text);

              await AuthRepository().addUser(UserModel(
                  udid: _auth.currentUser!.uid,
                  name: userNameController.text,
                  number: _auth.currentUser!.phoneNumber!,
                  openToChat: false,
                  inconversation: false));
              setState(() {
                showLoading = false;
              });
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: SizedBox(
              width: 150,
              child: !showLoading
                  ? const Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    )
                  : const Center(child: loadingWidget()),
            ))
      ],
    );
  }
}
