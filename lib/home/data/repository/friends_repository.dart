import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guessme/authentication/data/repository/authrepository.dart';
import 'package:guessme/home/data/models/friend_request_model.dart';
import 'package:guessme/main.dart';

import '../../../authentication/data/models/user_model.dart';

class FriendsRepository {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference receivedfrinedsRequestsCollection =
      FirebaseFirestore.instance
          .collection('users')
          .doc(sharedPref.udid)
          .collection('receivedfrinedsRequests');
  final CollectionReference sentfrinedsRequestsCollection = FirebaseFirestore
      .instance
      .collection('users')
      .doc(sharedPref.udid)
      .collection('sentfrinedsRequests');
  final CollectionReference friendsCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPref.udid)
      .collection('friends');

  sendFriendRequest(UserModel user) {
    userCollection
        .doc(user.udid)
        .collection('receivedfrinedsRequests')
        .doc(sharedPref.udid)
        .set(FriendsModel(accepted: false, createdAt: DateTime.now().toString())
            .toJson());
    userCollection
        .doc(sharedPref.udid)
        .collection('sentfrinedsRequests')
        .doc(user.udid)
        .set(FriendsModel(accepted: false, createdAt: DateTime.now().toString())
            .toJson());
  }

  acceptFriendRequest(UserModel user) async {
    userCollection
        .doc(user.udid)
        .collection('friends')
        .doc(sharedPref.udid)
        .set(FriendsModel(accepted: true, createdAt: DateTime.now().toString())
            .toJson());
    userCollection
        .doc(sharedPref.udid)
        .collection('friends')
        .doc(user.udid)
        .set(FriendsModel(accepted: true, createdAt: DateTime.now().toString())
            .toJson());
    userCollection
        .doc(sharedPref.udid)
        .collection('receivedfrinedsRequests')
        .doc(user.udid)
        .delete();

    userCollection
        .doc(user.udid)
        .collection('sentfrinedsRequests')
        .doc(sharedPref.udid)
        .delete();
  }

  declineFriendRequest(UserModel user) async {
    userCollection
        .doc(sharedPref.udid)
        .collection('receivedfrinedsRequests')
        .doc(user.udid)
        .delete();

    userCollection
        .doc(user.udid)
        .collection('sentfrinedsRequests')
        .doc(sharedPref.udid)
        .delete();
  }

  Future<List<UserModel>> getFriendRequests() async {
    QuerySnapshot snapshot = await receivedfrinedsRequestsCollection.get();
    List<UserModel> _friendList = [];

    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      log(id);
      UserModel user = await AuthRepository().getUserFromId(id);
      _friendList.add(user);
    }
    return _friendList;
  }

  Future<List<UserModel>> getsentFriendRequests() async {
    QuerySnapshot snapshot = await sentfrinedsRequestsCollection.get();
    List<UserModel> _friendList = [];

    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      log(id);
      UserModel user = await AuthRepository().getUserFromId(id);
      _friendList.add(user);
    }
    return _friendList;
  }

  Future<List<UserModel>> getFriends() async {
    QuerySnapshot snapshot = await friendsCollection.get();
    List<UserModel> _friendList = [];

    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      log(id);
      UserModel user = await AuthRepository().getUserFromId(id);
      _friendList.add(user);
    }
    return _friendList;
  }

  Future<List<UserModel>> getFriendsfromId({required String udid}) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(udid)
        .collection('friends')
        .get();
    List<UserModel> _friendList = [];

    for (String id in snapshot.docs.map((e) => e.id).toList()) {
      log(id);
      UserModel user = await AuthRepository().getUserFromId(id);
      _friendList.add(user);
    }
    return _friendList;
  }

  Future<List<UserModel>> getExploreFriends() async {
    List<UserModel> allUsers = await AuthRepository().getAllUsers();
    List<UserModel> friends = await getFriends();
    log("fr" + friends.toString());
    allUsers.removeWhere((element) =>
        friends.map((e) => e.udid).toList().contains(element.udid));
    return allUsers;
  }
}
