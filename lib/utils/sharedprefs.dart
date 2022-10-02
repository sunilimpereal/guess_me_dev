import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPref;
  init() async {
    if (_sharedPref == null) {
      _sharedPref = await SharedPreferences.getInstance();
    }
  }

  //gettter
  bool get loggedIn => _sharedPref!.getBool('loggedIn') ?? false;
  String get udid => _sharedPref!.getString('udid') ?? "";
  String get mobile => _sharedPref!.getString('mobile') ?? "";

  ///Set as logged in
  setLoggedIn() {
    _sharedPref!.setBool('loggedIn', true);
  }

  /// Set as logged out
  setLoggedOut() {
    _sharedPref!.setBool('loggedIn', false);
    setAuthToken(token: "");
    // _sharedPref!.remove('authToken');
  }

  /// Set  user details
  setUserDetails({required String udid, required String mobile}) {
    _sharedPref!.setString('udid', udid);
    _sharedPref!.setString('mobile', mobile);
  }

  ///set Auth token for the app
  setAuthToken({required String token}) {
    _sharedPref!.setString('authToken', token);
  }

  setVideoSourceType({required String source}) {
    _sharedPref!.setString('source', source);
  }
}

final sharedPrefs = SharedPref();
