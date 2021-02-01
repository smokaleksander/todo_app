import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  String token;
  DateTime expiryDate;
  String userId;

  Future<void> signUp(String email, String password)
}
