import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/models/user_response.dart';

class Database {
  final firestore = FirebaseFirestore.instance;

  final systemsRef =
      FirebaseFirestore.instance.collection('systems').withConverter<System>(
            fromFirestore: (snapshot, _) => System.fromMap(
              id: snapshot.id,
              data: snapshot.data()!,
            ),
            toFirestore: (system, _) => system.toMap(),
          );

/* ----------------------------- System queries ----------------------------- */

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
        // Update search results (system)
        firestore.collection('searchResults').doc(system.id).set(
              system.searchResultToMap(),
              SetOptions(merge: true),
            ),
        // Update problems docs
        updateProblems(problems: system.knownProblems, system: system)
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
    required UserResponse response,
    required Problem problem,
    required System system,
  }) async {
    try {
      return await Future.wait(
        [
          // Update solution doc
          firestore.collection('solutions').doc(response.id).set(
                response.toMap(),
                SetOptions(merge: true),
              ),
          firestore.collection('searchResults').doc(response.id).set(
                response.searchResultToMap(problem: problem, system: system),
                SetOptions(merge: true),
              ),
        ],
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  Future updateSolutions({
    required Problem problem,
    required System system,
  }) async {
    try {
      return await Future.forEach(problem.userResponses,
          (UserResponse response) {
        if (response.isOkResponse == false)
          updateSolution(response: response, problem: problem, system: system);
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  /* ----------------------------- Delete queries ----------------------------- */

  /// Deletes the system of `id` and returns the Future of this action.
  Future deleteSystem(String id) {
    return firestore.collection('systems').doc(id).delete();
  }
}
