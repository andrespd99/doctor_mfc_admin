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
      systemsRef.where('type', isEqualTo: type).snapshots();

  Stream<DocumentSnapshot<System>> getSystemByIdSnapshot(String id) =>
      systemsRef.doc(id).snapshots();

  Future addSystem(System system) async {
    try {
      final docRef = firestore.collection('systems').doc(system.id);

      await docRef.set(system.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future addSystems(List<System> systems) {
    return Future.forEach<System>(systems, (system) async {
      try {
        await firestore
            .collection('systems')
            .doc(system.id)
            .set(system.toMap());
      } catch (e) {
        // TODO: Catch errors.
      }
    });
  }

/* ---------------------------- Component queries --------------------------- */

  Future addComponent(Component component) async {
    try {
      return await firestore
          .collection('components')
          .doc(component.id)
          .set(component.toMap());
    } catch (e) {
      // TODO: Catch errors.
    }
  }

  Future addComponents(List<Component> components) async {
    try {
      return await Future.forEach<Component>(
          components,
          (component) async => await firestore
              .collection('components')
              .doc(component.id)
              .set(component.toMap()));
    } catch (e) {
      // TODO: Catch errors.
    }
  }
/* -------------------------- Known problem queries ------------------------- */

  Future addKnownProblem(Problem problem) async {
    try {
      return await firestore
          .collection('problems')
          .doc(problem.id)
          .set(problem.toMap());
    } catch (e) {
      // TODO: Catch errors.
    }
  }

  Future addKnownProblems(List<Problem> problems) async {
    try {
      return await Future.forEach<Problem>(
          problems,
          (problem) async => await firestore
              .collection('problems')
              .doc(problem.id)
              .set(problem.toMap()));
    } catch (e) {
      // TODO: Catch errors.
    }
  }
/* ------------------------- User responses queries ------------------------- */

  Future addResponse(UserResponse response) async {
    try {
      return await firestore
          .collection('userResponses')
          .doc(response.id)
          .set(response.toMap());
    } catch (e) {
      // TODO: Catch errors.
    }
  }

  Future addResponses(List<UserResponse> responses) async {
    try {
      return await Future.forEach<UserResponse>(
          responses,
          (response) async => await firestore
              .collection('userResponses')
              .doc(response.id)
              .set(response.toMap()));
    } catch (e) {
      // TODO: Catch errors.
    }
  }

/* ---------------------------- Solution queries ---------------------------- */
  Future addSolution(Solution solution) async {
    try {
      return await firestore
          .collection('solutions')
          .doc(solution.id)
          .set(solution.toMap());
    } catch (e) {
      // TODO: Catch errors.
    }
  }

  Future addSolutions(List<Solution> solutions) async {
    try {
      return await Future.forEach<Solution>(
          solutions,
          (solution) async => await firestore
              .collection('solutions')
              .doc(solution.id)
              .set(solution.toMap()));
    } catch (e) {
      // TODO: Catch errors.
    }
  }

  /* ----------------------------- Update queries ----------------------------- */

  Future updateSystem(System system) async {
    try {
      // Update system with the new data.
      await firestore
          .collection('systems')
          .doc(system.id)
          .update(system.toMap())
          .then((v) {
        // TODO: Notify change (?).
      });
    } catch (e) {}
  }

  /// Updates this problem in the database and returns the Future of this action.
  Future updateKnownProblem(Problem problem) {
    return firestore
        .collection('problems')
        .doc(problem.id)
        .update(problem.toMap());
  }

  /* ----------------------------- Delete queries ----------------------------- */

  /// Deletes the system of `id` and returns the Future of this action.
  Future deleteSystem(String id) {
    return firestore.collection('systems').doc(id).delete();
  }
}
