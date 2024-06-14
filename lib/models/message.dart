class Message {
  final dynamic message;
  final String fromId;
  final String toId;

  Message(
    this.message,
    this.fromId,
    this.toId,
  );

  factory Message.fromJsson(jsonData) {
    return Message(jsonData['message'], jsonData['fromId'], jsonData['toId']);
  }
}
