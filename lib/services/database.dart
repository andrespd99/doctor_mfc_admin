import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/models/test/test_system.dart';
import 'package:doctor_mfc_admin/models/user_response.dart';

class Database {
  final firestore = FirebaseFirestore.instance;

  final testSystemsRef = FirebaseFirestore.instance
      .collection('systems')
      .withConverter<TestSystem>(
        fromFirestore: (snapshot, _) =>
            TestSystem.fromMap(snapshot.id, snapshot.data()!),
        toFirestore: (system, _) => system.toMap(),
      );

/* ----------------------------- System queries ----------------------------- */

  Stream<QuerySnapshot<TestSystem>> getSystemsSnapshots() {
    return testSystemsRef.snapshots();
  }

  Future addSystem(System system) async {
    List<Component>? components = system.components;
    List<Problem> problems = system.knownProblems;
    List<UserResponse> responses = system.userResponses;
    List<Solution> solutions = system.solutions;

    try {
      return Future.wait([
        firestore.collection('systems').doc(system.id).set(system.toMap()),
        addComponents(components ?? []),
        addKnownProblems(problems),
        addResponses(responses),
        addSolutions(solutions),
      ]);
    } catch (e) {
      // TODO: Catch errors.
    }
  }

  Future addSystems(List<System> systems) {
    return Future.forEach<System>(systems, (system) async {
      List<Component>? components = system.components;
      List<Problem> problems = system.knownProblems;
      List<UserResponse> responses = system.userResponses;
      List<Solution> solutions = system.solutions;

      try {
        return await Future.wait([
          firestore.collection('systems').doc(system.id).set(system.toMap()),
          addComponents(components ?? []),
          addKnownProblems(problems),
          addResponses(responses),
          addSolutions(solutions),
        ]);
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
}
