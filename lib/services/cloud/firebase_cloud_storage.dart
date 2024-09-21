import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/services/cloud/cloud_note.dart';
import 'package:myapp/services/cloud/cloud_storage_constants.dart';
import 'package:myapp/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes =
      FirebaseFirestore.instance.collection('notes'); //declare notes varaible

  //Delete note
  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  //Update note
  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  //Grab theStream of notes for a specific user
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs //snapshot for live data
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  //Getting Notes from Firebase
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          ) //Verify Users
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)
                // {
                //   return CloudNote(
                //     documentId: doc.id,
                //     ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                //     text: doc.data()[textFieldName] as String,
                //   );
                // },
                ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  //Create document in firebase
  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    //provide doc to firebase
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  //1. Make FirebaseCloudStorage a singleton
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
