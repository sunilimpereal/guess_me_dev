import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/home/data/repository/friends_repository.dart';
import 'package:guessme/home/screens/homescreen.dart';
import 'package:guessme/main.dart';
import 'package:guessme/profile/screens/friends_list.dart';
import 'package:guessme/profile/screens/widgets/profile_picture.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;
  const ProfileScreen({super.key, required this.userModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.blueGrey.shade50,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 28,
                      ))
                ],
              ),
              profileSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileSection() {
    return FutureBuilder<UserModel>(
        future: AuthRepository().getUserFromId(widget.userModel.udid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          UserModel user = snapshot.data!;
          return Container(
            child: Column(
              children: [
                ProfilePicture(
                  userModel: widget.userModel,
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Add Friend")),
                    followerCount(),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget profileImage() {
    return Material(
      elevation: 10,
      color: Colors.white,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 100,
        height: 100,
      ),
    );
  }

  Widget followerCount() {
    return FutureBuilder<List<UserModel>>(
        future:
            FriendsRepository().getFriendsfromId(udid: widget.userModel.udid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          List<UserModel> friends = snapshot.data!;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FriendsListScreen(
                            friends: friends,
                          )));
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    friends.length.toString(),
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Friends",
                    style: TextStyle(color: Colors.grey.shade700),
                  )
                ],
              ),
            ),
          );
        });
  }
}
