import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';

import 'package:guessme/home/data/repository/friends_repository.dart';
import 'package:guessme/home/screens/widgets/drawer.dart';
import 'package:guessme/home/screens/widgets/friend_card.dart';
import 'package:guessme/home/screens/widgets/friend_request_card.dart';
import 'package:guessme/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      scaffoldKey: scaffoldKey,
      child: Column(
        children: [
          friends(),
        ],
      ),
    );
  }

  Widget friends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            "Friends",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        FutureBuilder<List<UserModel>>(
            future: FriendsRepository().getFriends(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return Column(
                  children: snapshot.data!
                      .map((e) => FriendCard(userModel: e))
                      .toList());
            }),
      ],
    );
  }

  Widget friendsRequests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            "Friends Requests",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        Container(
          child: FutureBuilder<List<UserModel>>(
              future: FriendsRepository().getFriendRequests(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return Column(
                    children: snapshot.data!
                        .map((e) => FriendRequestCard(userModel: e))
                        .toList());
              }),
        ),
      ],
    );
  }
}

class HomeScaffold extends StatefulWidget {
  final Widget child;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeScaffold(
      {super.key, required this.child, required this.scaffoldKey});

  @override
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  @override
  Widget build(BuildContext context) {
    AuthRepository().updateuserlastSeen(sharedPref.udid);
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: const HomeDrawer(),
      backgroundColor: Colors.blueGrey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      widget.scaffoldKey.currentState?.openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      size: 28,
                    ))
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [widget.child],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
