class Message {
  final String id;
  final String text;
  final bool isOwn;

  Message({
    required this.id,
    required this.text,
    required this.isOwn,
  });

  factory Message.create(String text, bool isOwner) {
    return Message(
      id: '1',
      text: text,
      isOwn: isOwner,
    );
  }
}