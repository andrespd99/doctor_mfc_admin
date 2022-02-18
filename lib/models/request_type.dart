/// Enum for request types, which can be either add or update.
enum RequestType { ADD, UPDATE }

class RequestTypeConverter {
  static typeToString(RequestType type) {
    switch (type) {
      case RequestType.ADD:
        return 'add';
      case RequestType.UPDATE:
        return 'update';
      default:
        return 'unknown';
    }
  }

  static stringToType(String type) {
    switch (type.toLowerCase()) {
      case 'add':
        return RequestType.ADD;
      case 'update':
        return RequestType.UPDATE;
      default:
        throw new Exception('Unknown request type: $type');
    }
  }
}
