import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  // get collection data
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // create and add data
  Future<void> addUser(
    String name,
    String email,
    String phone,
    String dob,
    String gender,
    String address,
  ) async {
    try {
      DocumentReference userDoc = users.doc(email);
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        throw Exception('This email already exist...');
      }
      await userDoc.set({
        'name': name,
        'email': email,
        'phone': phone,
        'dob': dob,
        'gender': gender,
        'address': address,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error to register user!!');
      rethrow;
    }
  }

  // read the data

  Future<DocumentSnapshot?> getUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    DocumentSnapshot doc = await users.doc(user.email).get();
    return doc.exists ? doc : null;
  }

  // update the data

  Future<void> updateData(String email, Map<String, dynamic> newData) async {
    try {
      await users.doc(email).update(newData);
    } catch (e) {
      print(e);
    }
  }

  final CollectionReference stations =
      FirebaseFirestore.instance.collection('stations');

  // read station
  Stream<QuerySnapshot> getStationDetails() {
    final stationDetails =
        stations.orderBy('stationcode', descending: true).snapshots();
    return stationDetails;
  }

  // read message data

  final CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  Stream<QuerySnapshot> getMessage() {
    final messageDetails =
        messages.orderBy('timestamp', descending: true).snapshots();
    return messageDetails;
  }

  Stream<List<Map<String, dynamic>>> fetchTicketData() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Stream.empty();
    }
    String userEmail = user.email!;

    CollectionReference bookings = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('bookings');

    return bookings
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  Future<void> cancelTickt(String ticketId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userEmail = user.email!;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('bookings')
        .doc(ticketId)
        .update({'bookingStatus': 'cancelled'});
  }
}
