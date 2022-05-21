import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/cloud/cloud_storage_contants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudData {
  final String documentId;
  final String ownerUserId;
  final String text;
  const CloudData({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  CloudData.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFeildName],
        text = snapshot.data()[textFeildName] as String;
}
