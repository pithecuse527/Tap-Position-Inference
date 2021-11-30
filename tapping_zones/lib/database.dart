import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Database {
  late FirebaseFirestore firestore;

  initiliaze() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> create(var accelerometer, var gyroscope, var tap_position_x,
      var tap_position_y, var pitch, var roll, var tapped_zone) async {
    try {
      await firestore.collection("sensor_data").add({
        'accelerometer1': accelerometer[0],
        'accelerometer2': accelerometer[1],
        'accelerometer3': accelerometer[2],
        'gyroscope1': gyroscope[0],
        'gyroscope2': gyroscope[1],
        'gyroscope3': gyroscope[2],
        'pitch': pitch,
        'roll': roll,
        'tap_position_x': tap_position_x,
        'tap_position_y': tap_position_y,
        'tapped_zone': tapped_zone
      });
    } catch (e) {
      print(e);
    }
  }
}
