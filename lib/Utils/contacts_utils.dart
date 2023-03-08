import 'package:permission_handler/permission_handler.dart';

class ContactUtils {
  static Future<PermissionStatus> getContactPermission() async {
    final permission = await Permission.contacts.status;

    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      final newPermission = await Permission.contacts.request();

      return newPermission;
    } else {
      return permission;
    }
  }
}
