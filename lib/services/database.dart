import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/models/attachment.dart';
import 'package:doctor_mfc_admin/models/enums/attachment_type.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Database {
  final firestore = FirebaseFirestore.instance;

/* --------------------------- Document references -------------------------- */

  final systemsRef =
      FirebaseFirestore.instance.collection('systems').withConverter<System>(
            fromFirestore: (snapshot, _) => System.fromMap(
              id: snapshot.id,
              data: snapshot.data()!,
            ),
            toFirestore: (system, _) => system.toMap(),
          );

  final fileRef = FirebaseFirestore.instance
      .collection('documents')
      .withConverter<FileAttachment>(
        fromFirestore: (snapshot, _) => FileAttachment.fromMap(
          snapshot.id,
          snapshot.data()!,
        ),
        toFirestore: (fileAttachment, _) => fileAttachment.toMap(),
      );

/* ----------------------------- System queries ----------------------------- */

  Future<QuerySnapshot<System>> getAllSystems() => systemsRef.get();

  Stream<QuerySnapshot<System>> getSystemsSnapshots() => systemsRef.snapshots();

  Stream<QuerySnapshot<System>> getSystemsByTypeSnapshots(String type) =>
      systemsRef.where('type', isEqualTo: type.toLowerCase()).snapshots();

  Stream<DocumentSnapshot<System>> getSystemSnapshotById(String id) =>
      systemsRef.doc(id).snapshots();

  Future addSystems(List<System> systems) async {
    try {
      // Update fuction does the same that adding would.
      return await updateSystems(systems);
    } catch (e) {
      print(e);
    }
  }

/* -------------------------- Known problem queries ------------------------- */

  Future addProblems({
    required List<Problem> problems,
    required System system,
  }) async {
    try {
      // Update fuction does the same that adding would.
      return await updateProblems(problems: problems, system: system);
    } catch (e) {
      print(e);
      // TODO: Catch errors.
    }
  }

  /* ----------------------------- Update queries ----------------------------- */

  Future updateSystem(System system) async {
    try {
      // Update system with the new data.
      return await Future.wait([
        // Update system's doc
        firestore
            .collection('systems')
            .doc(system.id)
            .set(system.toMap(), SetOptions(merge: true)),
        // Update problems docs
        updateProblems(problems: system.problems, system: system)
      ]);
    } catch (e) {
      print(e);
    }
  }

  Future updateSystems(List<System> systems) async {
    try {
      return await Future.forEach<System>(
        systems,
        (system) async => await updateSystem(system),
      );
    } catch (e) {
      print(e);
    }
  }

  /// Updates this problem in the database and returns the Future of this action.
  Future updateProblem({
    required Problem problem,
    required System system,
  }) async {
    try {
      return await Future.wait([
        // Update problem doc
        firestore
            .collection('problems')
            .doc(problem.id)
            .set(problem.searchResultToMap(system)),
        // Update search results doc (problem).
        firestore
            .collection('searchResults')
            .doc(problem.id)
            .set(problem.searchResultToMap(system), SetOptions(merge: true)),
        // Update search results doc (solutions).
        updateSolutions(problem: problem, system: system)
      ]);
    } on Exception catch (e) {
      print(e);
    }
  }

  /// Updates these problems in the database and returns the Future of this action.
  Future updateProblems({
    required List<Problem> problems,
    required System system,
  }) async {
    try {
      return await Future.forEach(problems,
          (Problem problem) => updateProblem(problem: problem, system: system));
    } on Exception catch (e) {
      print(e);
    }
  }

  Future updateSolution({
    required Solution solution,
    required Problem problem,
    required System system,
  }) async {
    try {
      return await firestore
          .collection('solutions')
          .doc(solution.id)
          .set(solution.toMap(), SetOptions(merge: true));
    } on Exception catch (e) {
      print(e);
    }
  }

  Future updateSolutions({
    required Problem problem,
    required System system,
  }) async {
    try {
      return await Future.forEach(
          problem.solutions,
          (Solution solution) => updateSolution(
                solution: solution,
                problem: problem,
                system: system,
              ));
    } on Exception catch (e) {
      print(e);
    }
  }

  /* ----------------------------- Delete queries ----------------------------- */

  /// Deletes the system of `id` and returns the Future of this action.
  Future deleteSystem(String id) {
    return firestore.collection('systems').doc(id).delete();
  }

  /* ------------------------------ File queries ------------------------------ */

  Stream<QuerySnapshot<FileAttachment>> getAllDocumentation() => fileRef
      .where('type', isEqualTo: typeToCodeMap[AttachmentType.DOCUMENTATION])
      .snapshots();

  Stream<QuerySnapshot<FileAttachment>> getAllGuides() => fileRef
      .where('type', isEqualTo: typeToCodeMap[AttachmentType.GUIDE])
      .snapshots();

  /// Uploads file to Firebase Storage, sets file data to FileAttachment object
  /// and returns true if the future completes successfully.
  Future<bool?> addAttachment(
    FileAttachment attachment,
    PlatformFile file,
  ) async {
    String? fileUrl;

    fileUrl = await _uploadFile(file);

    attachment.fileUrl = fileUrl;
    attachment.setFileData(file, fileUrl);

    try {
      await firestore
          .collection('documents')
          .doc(attachment.id)
          .set(attachment.toMap(), SetOptions(merge: true));
      await firestore
          .collection('searchResults')
          .doc(attachment.id)
          .set(attachment.toMap(), SetOptions(merge: true));

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool?> updateAttachment(
    FileAttachment attachment,
    PlatformFile? file,
  ) async {
    if (file != null)
      return addAttachment(attachment, file);
    else {
      try {
        await firestore
            .collection('documents')
            .doc(attachment.id)
            .set(attachment.toMap(), SetOptions(merge: true));
        await firestore
            .collection('searchResults')
            .doc(attachment.id)
            .set(attachment.toMap(), SetOptions(merge: true));

        return true;
      } on Exception catch (e) {
        print(e);
        return false;
      }
    }
  }

  Future<FileAttachment?> getFileAttachment(String id) async {
    return await firestore
        .collection('documents')
        .doc(id)
        .get()
        .then((snapshot) {
      if (snapshot.exists)
        return FileAttachment.fromMap(snapshot.id, snapshot.data()!);
    });
  }

  /* -------------------------------------------------------------------------- */

  Future<String> _uploadFile(PlatformFile file) async {
    assert(file.bytes != null);
    Uint8List fileBytes = file.bytes!;

    Reference fileRef = FirebaseStorage.instance.ref('uploads/${file.name}');

    await fileRef.putData(fileBytes);

    return fileRef.getDownloadURL();
  }
}
