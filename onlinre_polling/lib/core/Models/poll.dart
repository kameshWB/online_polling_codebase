import 'package:cloud_firestore/cloud_firestore.dart';

class Poll {
  int id;
  String title;
  String des;
  bool isClosed;
  String date;
  int priority;
  int status;
  String type;
  String question;

  Poll({
    this.id = 0,
    this.title = '',
    this.des = '',
    this.isClosed = false,
    this.date = '',
    this.priority = 1,
    this.status = 1,
    this.type = '',
    this.question = '',
  });

  factory Poll.fromFirestore(DocumentSnapshot snapshot) {
    int getIntValue(DocumentSnapshot snapshot, String key) {
      try {
        var v = snapshot.get(key);
        if (v == null) return 0;
        return v;
      } catch (e) {
        return 0;
      }
    }

    bool getBoolValue(DocumentSnapshot snapshot, String key) {
      try {
        var v = snapshot.get(key);
        if (v == null) return false;
        return v;
      } catch (e) {
        return false;
      }
    }

    String getStringValue(DocumentSnapshot snapshot, String key) {
      try {
        var v = snapshot.get(key);
        if (v == null) return "";
        return v;
      } catch (e) {
        return "";
      }
    }

    return Poll(
      id: getIntValue(snapshot, "id"),
      title: getStringValue(snapshot, "title"),
      des: getStringValue(snapshot, "des"),
      isClosed: getBoolValue(snapshot, "isClosed"),
      date: getStringValue(snapshot, "date"),
      priority: getIntValue(snapshot, "priority"),
      status: getIntValue(snapshot, "status"),
      type: getStringValue(snapshot, "type"),
      question: getStringValue(snapshot, "question"),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "des": des,
      "isClosed": isClosed,
      "date": date,
      "priority": priority,
      "status": status,
      "type": type,
      "question": question,
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}
