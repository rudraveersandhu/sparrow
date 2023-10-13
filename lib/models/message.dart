class Message{
  Message({
   required this.receiverID,
    required this.message,
    required this.read,
    required this.type,
    required this.senderID,
    required this.sent,
    required this.senderName,
  });
  late final String receiverID;
  late final String message;
  late final String read;
  late final String senderID;
  late final String sent;
  late final Type type;
  late final String senderName;

  Message.fromJson(Map<String, dynamic> json){
    receiverID = json['receiverID'].toString();
    message    = json['message'].toString();
    read       = json['read'].toString() ;
    type       = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    senderID   = json['senderID'].toString();
    sent       = json['sent'].toString();
    senderName = json['senderName'].toString();
  }

  Map<String, dynamic> toJson(){
    final data = <String, dynamic>{};
      data['receiverID'] = receiverID;
      data['message'] = message;
      data['read'] = read;
      data['type'] = type.name;
      data['senderID'] = senderID;
      data['sent'] = sent;
      data['senderName'] = senderName;
      return data;
  }
}

enum Type { text, image }