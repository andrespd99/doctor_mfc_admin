import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/models/app_user.dart';
import 'package:doctor_mfc_admin/models/attachment.dart';
import 'package:doctor_mfc_admin/models/enums/attachment_type.dart';

import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/role.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Database {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

/* --------------------------- Document references -------------------------- */

  /// Systems collection reference with to [System] converter.
  final _systemsRef =
      FirebaseFirestore.instance.collection('systems').withConverter<System>(
            fromFirestore: (snapshot, _) => System.fromMap(
              id: snapshot.id,
              data: snapshot.data()!,
            ),
            toFirestore: (system, _) => system.toMap(),
          );

  /// Files collection reference with to [FileAttachment] converter.
  final _fileRef = FirebaseFirestore.instance
      .collection('documents')
      .withConverter<FileAttachment>(
        fromFirestore: (snapshot, _) => FileAttachment.fromMap(
          snapshot.id,
          snapshot.data()!,
        ),
        toFirestore: (fileAttachment, _) => fileAttachment.toMap(),
      );

  /// Users collection reference with to [AppUser] converter.
  final _usersRef =
      FirebaseFirestore.instance.collection('users').withConverter<AppUser>(
            fromFirestore: (snapshot, _) => AppUser.fromMap(
              id: snapshot.id,
              data: snapshot.data()!,
            ),
            toFirestore: (user, _) => user.toMap(),
          );

  /// Returns a Future of all [System] objects in Firebase Firestore.
  Future<QuerySnapshot<System>> getAllSystems() => _systemsRef.get();

  /// Returns a Future of a [System] of given `id` in Firebase Firestore.
  Future<System?> getSystemById(String id) =>
      _systemsRef.doc(id).get().then<System?>((value) => value.data());

  /// Returns the snapshots of all systems in Firebase Firestore.
  Stream<QuerySnapshot<System>> getSystemsSnapshots() =>
      _systemsRef.snapshots();

  /// Returns the snapshots of all users in Firebase Firestore.
  Stream<QuerySnapshot<AppUser>> getUsersSnapshots() =>
      _usersRef.orderBy('disabled').snapshots();

  /// Returns a [Stream] of all [System]s with given `type` in Firebase Firestore.
  Stream<QuerySnapshot<System>> getSystemsByTypeSnapshots(String type) =>
      _systemsRef.where('type', isEqualTo: type.toLowerCase()).snapshots();

  /// Returns a [Stream] of a [System] with given `id` in Firebase Firestore.
  Stream<DocumentSnapshot<System>> getSystemSnapshotById(String id) =>
      _systemsRef.doc(id).snapshots();

  /// Adds all systems to Firebase Firestore and returns the future of this action.
  Future addSystems(List<System> systems) async {
    try {
      // Update fuction does the same that adding would.
      return await updateSystems(systems);
    } catch (e) {
      print(e);
    }
  }

  /// Adds all problems to Firebase Firestore and returns the future of this action.
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

  /// Updates this system's document with it's latest data in Firebase Firestore and returns the future of this action.
  Future updateSystem(System system) async {
    try {
      // Update system with the new data.
      return await Future.wait([
        // Update system's doc
        _firestore
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

  /// Updates all systems' documents with it's latest data in Firebase Firestore and returns the future of this action.
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

  /// Updates this problem's document in Firebase Firestore and returns the Future of this action.
  Future updateProblem({
    required Problem problem,
    required System system,
  }) async {
    try {
      return await Future.wait([
        // Update problem doc
        _firestore
            .collection('problems')
            .doc(problem.id)
            .set(problem.searchResultToMap(system)),
        // Update search results doc (problem).
        _firestore
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

  /// Updates all problems documents in Firebase Firestore and returns the Future of this action.
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

  /// Updates this solution's document in Firebase Firestore and returns the Future of this action.
  Future updateSolution({
    required Solution solution,
    required Problem problem,
    required System system,
  }) async {
    try {
      return await _firestore
          .collection('solutions')
          .doc(solution.id)
          .set(solution.toMap(), SetOptions(merge: true));
    } on Exception catch (e) {
      print(e);
    }
  }

  /// Updates all solutions documents in Firebase Firestore and returns the Future of this action.
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

  /// Deletes the system of given `id` and returns the Future of this action.
  Future deleteSystem(String id) {
    return _firestore.collection('systems').doc(id).delete();
  }

  /* ------------------------------ File queries ------------------------------ */

  /// Returns a Stream of all [FileAttachment]s in the database with type
  /// [AttachmentType.DOCUMENTATION].
  Stream<QuerySnapshot<FileAttachment>> getAllDocumentation() => _fileRef
      .where('type',
          isEqualTo:
              AttachmentTypeConverter.typeToCode(AttachmentType.DOCUMENTATION))
      .snapshots();

  /// Returns a Stream of all [FileAttachment]s in the database with type
  /// [AttachmentType.GUIDES].
  Stream<QuerySnapshot<FileAttachment>> getAllGuides() => _fileRef
      .where('type',
          isEqualTo: AttachmentTypeConverter.typeToCode(AttachmentType.GUIDE))
      .snapshots();

  /// Uploads file to Firebase Storage, sets file data to a [FileAttachment] object
  /// and returns true if the future completes successfully.
  Future<bool?> addAttachment(
    FileAttachment attachment,
    PlatformFile? file,
  ) async =>
      updateAttachment(attachment, file);

  /// Updates attachment with the new data. Returns true if the future completes
  /// successfully.
  Future<bool?> updateAttachment(
    FileAttachment attachment,
    PlatformFile? file,
  ) async {
    System? system;

    if (file != null) {
      String? fileUrl;

      fileUrl = await _uploadFile(file);

      attachment.fileUrl = fileUrl;
      attachment.setFileData(file, fileUrl);
    }
    if (attachment.type == AttachmentType.DOCUMENTATION) {
      assert(attachment.systemId != null);
      system = await getSystemById(attachment.systemId!);
    }

    try {
      await _firestore
          .collection('documents')
          .doc(attachment.id)
          .set(attachment.toMap(), SetOptions(merge: true));
      await _firestore
          .collection('searchResults')
          .doc(attachment.id)
          .set(attachment.searchResultToMap(system), SetOptions(merge: true));

      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  /// Gets the file data from Firebase Firestore and returns a [FileAttachment] object.
  Future<FileAttachment?> getFileAttachment(String id) async {
    return await _firestore
        .collection('documents')
        .doc(id)
        .get()
        .then((snapshot) {
      if (snapshot.exists)
        return FileAttachment.fromMap(snapshot.id, snapshot.data()!);
    });
  }

  /* -------------------------------------------------------------------------- */

  /// Uploads file to Firebase Storage and returns the file URL.
  Future<String> _uploadFile(PlatformFile file) async {
    assert(file.bytes != null);
    Uint8List fileBytes = file.bytes!;

    Reference fileRef = FirebaseStorage.instance.ref('uploads/${file.name}');

    await fileRef.putData(fileBytes);

    return fileRef.getDownloadURL();
  }

  /// Creates a new user account in Firebase Authentication SDK
  /// with email and password, then creates a new user document in the database.
  ///
  /// A [Role] can be set different than [Role.USER] if the user is an admin or super admin.
  Future createUser({
    required String userName,
    required String userEmail,
    required String password,
    Role role = Role.USER,
  }) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: userEmail,
        password: password,
      )
          .then((credentials) async {
        assert(credentials.user != null);
        await _firestore
            .collection('users')
            .doc(credentials.user!.uid)
            .set(new AppUser(
              id: credentials.user!.uid,
              userName: userName,
              userEmail: userEmail,
              role: role,
            ).toMap());
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  /// Disables user account with the given ID. This sets the user's document attribute 'disabled' to `true`.
  Future disableUser(String id) async {
    try {
      await _firestore.collection('users').doc(id).update({'disabled': true});
    } on Exception catch (e) {
      print(e);
    }
  }

  /// Enables user account with the given ID. This sets the user's document attribute 'disabled' to `false`.
  Future enableUser(String id) async {
    try {
      await _firestore.collection('users').doc(id).update({'disabled': false});
    } on Exception catch (e) {
      print(e);
    }
  }
}
