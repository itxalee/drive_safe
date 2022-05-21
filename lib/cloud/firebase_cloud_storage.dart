import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/cloud/cloud_data.dart';
import 'package:drive_safe/cloud/cloud_storage_contants.dart';
import 'cloud_storage_exception.dart';

class FirebaseCloudStorage {
  final data = FirebaseFirestore.instance.collection('data');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await data.doc(documentId).delete();
    } catch (e) {
      throw CloudNotDeleteException();
    }
  }

  Future<void> updateData({
    required String documentId,
    required String text,
  }) async {
    try {
      await data.doc(documentId).update({textFeildName: text});
    } catch (e) {
      throw CloudNotUpdateException();
    }
  }

  Stream<Iterable<CloudData>> allData({required String ownerUserId}) {
    final allData = data
        .where(ownerUserIdFeildName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudData.fromSnapshot(doc)));
    return allData;
  }

  Future<CloudData> createNewData({required String ownerUserId}) async {
    final document = await data.add({
      ownerUserIdFeildName: ownerUserId,
      textFeildName: '',
    });
    final fetchedData = await document.get();
    return CloudData(
      documentId: fetchedData.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
