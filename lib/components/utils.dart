import 'package:flutter/material.dart';



import 'package:flutter/foundation.dart';

class ProfileProvider with ChangeNotifier {
    String _profilePictureUrl = '';

    String get profilePictureUrl => _profilePictureUrl;

    void setProfilePictureUrl(String url) {
        _profilePictureUrl = url;
        notifyListeners();
    }
}
