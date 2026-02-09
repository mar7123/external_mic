import "package:uuid/uuid.dart";

class IdUtils {
  static String generateRandomId() {
    return const Uuid().v4();
  }
}
