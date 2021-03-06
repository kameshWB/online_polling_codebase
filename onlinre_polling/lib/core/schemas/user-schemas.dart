import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onlinre_polling/core/authentication/firebase_auth.dart';

///*****************************************************************
///
///                     UserProfile Schema
///
///*****************************************************************

const JSONObj = {
  "uid": "dscsd8s7ds7dv9d7yv8s6dvsf8ds8s7d8fssdf8cs",
  "firstName": "Amisha",
  "lastName": "Padsala",
  "email": "kamesh@gmail.com",
};

class DataSchemas {
  /// User profiles
  static var profileData = FirebaseFirestore.instance
      .collection("userProfiles")
      .doc(FirebaseAuthentication.getUserID());

  /// Submissions
  static var eventSubmissions = FirebaseFirestore.instance
      .collection("eventSubmissions");

  /// pollRequest counter
  static var pollRequestCount =
      FirebaseFirestore.instance.collection("counter").doc('pollRequest');

  /// event counter
  static var eventCount =
      FirebaseFirestore.instance.collection("counter").doc('event');

  /// event counter
  static var events = FirebaseFirestore.instance.collection("events");

  /// event counter
  static var polls = FirebaseFirestore.instance.collection("polls");

  /// event submission counter
  static var eventsSubmissionCount = FirebaseFirestore.instance.collection("counter").doc('eventSubmissions');

  /// poll counter
  static var pollCount =
      FirebaseFirestore.instance.collection("counter").doc('poll');
}

class DataStreams {
  static var closedEvents = FirebaseFirestore.instance
      .collection("events")
      .where('isClosed', isEqualTo: true)
      // .orderBy('id', descending: true)
      .snapshots();

  static var polls = FirebaseFirestore.instance
      .collection("polls")
      .orderBy('id', descending: true)
      .snapshots();

  static var events = FirebaseFirestore.instance
      .collection("events")
      .orderBy('id', descending: true)
      .snapshots();

  static var activeEvents = FirebaseFirestore.instance
      .collection("events")
      .where('isClosed', isEqualTo: false)
      // .orderBy('id', descending: true)
      // .orderBy('id')
      .snapshots();

  static var needResponse = FirebaseFirestore.instance
      .collection("events")
      .where('isClosed', isEqualTo: false)
      .where('status', isEqualTo: 1)
      .where('priority', isEqualTo: 3)
      // .orderBy('id', descending: true)
      // .orderBy('id')
      .snapshots();
}

class DataGets {
  static var closedEvents = FirebaseFirestore.instance
      .collection("events")
      .where('isClosed', isEqualTo: true)
      .get();

  static var activeEvents = FirebaseFirestore.instance
      .collection("events")
      .where('isClosed', isEqualTo: false)
      .get();
  static var needResponse = FirebaseFirestore.instance
      .collection("events")
      .where('isClosed', isEqualTo: false)
      .where('status', isEqualTo: 1)
      .where('priority', isEqualTo: 3)
      .get();
}
