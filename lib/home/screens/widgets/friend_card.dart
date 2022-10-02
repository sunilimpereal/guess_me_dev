import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/home/data/bloc/friends_bloc.dart';
import 'package:guessme/home/screens/widgets/user_card_home.dart';

import '../../../profile/screens/profile_screen.dart';
import '../../../profile/screens/widgets/card_profile_picture.dart';
import '../../data/repository/friends_repository.dart';

class FriendCard extends StatefulWidget {
  final UserModel userModel;
  const FriendCard({super.key, required this.userModel});

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
        stream: FriendsProvider.of(context).friendsReceivedRequestListStream,
        builder: (context, snapshotReceived) {
          return StreamBuilder<List<UserModel>>(
              stream: FriendsProvider.of(context).friendsSentRequestListStream,
              builder: (context, snapshotSent) {
                List<UserModel> receivedRequest = snapshotReceived.data ?? [];
                List<UserModel> sentRequest = snapshotSent.data ?? [];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.hardEdge,
                    child: Ink(
                      child: InkWell(
                        highlightColor: Colors.white,
                        splashColor: Colors.red.shade50,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        userModel: widget.userModel,
                                      )));
                        },
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          // color: Colors.white
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CardProfilePicture(
                                      udid: widget.userModel.udid),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  nameSec(widget.userModel)
                                ],
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: Colors.grey.shade100),
                                  onPressed: () async {},
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.solidMessage,
                                        color: Colors.red.shade600,
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
