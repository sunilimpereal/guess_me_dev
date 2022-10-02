import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:guessme/authentication/data/models/user_model.dart';
import 'package:guessme/home/data/bloc/friends_bloc.dart';
import 'package:guessme/home/data/repository/friends_repository.dart';

import '../../../profile/screens/profile_screen.dart';

class UserCardHome extends StatefulWidget {
  final UserModel userModel;
  const UserCardHome({Key? key, required this.userModel}) : super(key: key);

  @override
  State<UserCardHome> createState() => _UserCardHomeState();
}

class _UserCardHomeState extends State<UserCardHome> {
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
                log(receivedRequest.toString());
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
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    widget.userModel.name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              functionButtons(
                                  receivedRequests: receivedRequest,
                                  sentRequests: sentRequest)
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

  Widget functionButtons({
    required List<UserModel> receivedRequests,
    required List<UserModel> sentRequests,
  }) {
    if (receivedRequests.map((e) => e.udid).contains(widget.userModel.udid)) {
      return Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade400),
              onPressed: () async {
                FriendsProvider.of(context).updateFriends();
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.cancel,
                    size: 20,
                  ),
                ],
              )),
          const SizedBox(
            width: 8,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () async {
                FriendsProvider.of(context).updateFriends();
                await FriendsRepository().acceptFriendRequest(widget.userModel);
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.check,
                    size: 20,
                  ),
                  Text("Accept")
                ],
              )),
        ],
      );
    } else if (sentRequests
        .map((e) => e.udid)
        .contains(widget.userModel.udid)) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.grey.shade400,
          ),
          onPressed: () async {
            FriendsProvider.of(context).updateFriends();
            await FriendsRepository().sendFriendRequest(widget.userModel);
          },
          child: Row(
            children: const [
              Icon(
                Icons.hail,
                size: 20,
              ),
              Text("Requested")
            ],
          ));
    } else {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(),
          onPressed: () async {
            FriendsProvider.of(context).updateFriends();
            await FriendsRepository().sendFriendRequest(widget.userModel);
          },
          child: Row(
            children: const [
              Icon(
                Icons.add,
                size: 20,
              ),
              Text("ADD")
            ],
          ));
    }
  }
}
