
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/custom_widgets/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog{
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super (
    title: title,
    content: _message(exception),
    defaultActionText: 'OK'
  );

 static String _message(PlatformException exception) {
    if (exception.message == 'FIRFirestoreErrorDomain') {
      if (exception.code == 'Error 7') {
        return 'Missing or insufficient permissions';
      }
    }
    return _errors[exception.code] ?? exception.message;
  }
  static Map<String, String> _errors = {
      'ERROR_WEAK_PASSWORD' : 'The password is not strong enough',
      'ERROR_INVALID_EMAIL' : 'The email address is malformed.',
      'ERROR_EMAIL_ALREADY_IN_USE' : 'The email is already in use by a different account.',
      'ERROR_WRONG_PASSWORD' : 'The [password] is wrong.',
      'ERROR_USER_NOT_FOUND' : 'There is no user corresponding to the given [email] address, or if the user has been deleted.',
      'ERROR_USER_DISABLED' : 'The user has been disabled (for example, in the Firebase console)',
      'ERROR_TOO_MANY_REQUESTS' : 'There was too many attempts to sign in as this user.',
      'ERROR_OPERATION_NOT_ALLOWED' : ' Email & Password accounts are not enabled.',
  };


}