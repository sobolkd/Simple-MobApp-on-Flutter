import 'package:my_project/database_helper.dart';
import 'package:my_project/user.dart';

class AutoLoginService {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  Future<User?> checkAutoLogin() async {
    final users = await databaseHelper.getUsers();

    for (var user in users) {
      if (user['is_logged_in'] == 1) {
        final firstName = user['first_name'] as String;
        final lastName = user['last_name'] as String;
        final email = user['email'] as String;

        UserDataProvider.currentUser = User(
          firstName: firstName,
          lastName: lastName,
          email: email,
        );

        return UserDataProvider.currentUser;
      }
    }

    return null;
  }
}
