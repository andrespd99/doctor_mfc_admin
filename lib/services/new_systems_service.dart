import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/problem.dart';
import 'package:doctor_mfc_admin/models/solution.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/models/user_response.dart';

class SystemsService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<System>? getSystemById(String systemId) async {
    return _db.collection('system').doc('$systemId').get().then((doc) async {
      List<String>? componentsIds = List.from(doc.data()?['components']);

      final components = await getComponentsByIds(componentsIds);

      return System.fromMap(
        id: doc.id,
        data: doc.data()!,
        components: components,
      );
    });
  }

  Future<List<System>>? getSystemsByIds(List<String> ids) async {
    List<Future<System>> systems = ids.map<Future<System>>((systemId) {
      return _db
          .collection('systems')
          .doc('$systemId')
          .get()
          .then((systemDoc) async {
        List<String>? componentsIds =
            List.from(systemDoc.data()?['components']);

        final components = await getComponentsByIds(componentsIds);

        return System.fromMap(
          id: systemDoc.id,
          data: systemDoc.data()!,
          components: components,
        );
      });
    }).toList();

    return Future.wait(systems);
  }

  Future<List<Component>>? getComponentsByIds(List<String>? ids) async {
    if (ids == null) return [];

    List<Future<Component>> components =
        ids.map<Future<Component>>((componentId) {
      return _db
          .collection('components')
          .doc('$componentId')
          .get()
          .then((componentDoc) async {
        List<String>? problemsIds = List.from(componentDoc.data()?['problems']);

        final problems = await getKnownProblemsByIds(problemsIds);

        return Component.fromMap(
          id: componentDoc.id,
          data: componentDoc.data()!,
          problems: problems,
        );
      });
    }).toList();

    return Future.wait(components);
  }

  Future<List<Problem>>? getKnownProblemsByIds(List<String>? ids) async {
    if (ids == null) return [];

    List<Future<Problem>> problems = ids.map<Future<Problem>>((problemId) {
      return _db
          .collection('problems')
          .doc('$problemId')
          .get()
          .then((problemDoc) async {
        List<String>? responsesIds =
            List.from(problemDoc.data()?['userResponses']);

        final responses = await getUserResponsesByIds(responsesIds);

        return Problem.fromMap(
          id: problemDoc.id,
          data: problemDoc.data()!,
          userResponses: responses,
        );
      });
    }).toList();

    return Future.wait(problems);
  }

  Future<List<UserResponse>>? getUserResponsesByIds(List<String>? ids) async {
    if (ids == null) return [];

    List<Future<UserResponse>> userResponses =
        ids.map<Future<UserResponse>>((responseId) {
      return _db
          .collection('responses')
          .doc('$responseId')
          .get()
          .then((responseDoc) async {
        List<String> solutionsIds = List.from(responseDoc.data()?['solutions']);

        final solutions = await getSolutionsByIds(solutionsIds);

        return UserResponse.fromMap(
          id: responseDoc.id,
          data: responseDoc.data()!,
          solutions: solutions,
        );
      });
    }).toList();

    return Future.wait(userResponses);
  }

  /// Fetches the list of solutions from the given IDs.
  Future<List<Solution>>? getSolutionsByIds(List<String>? ids) async {
    if (ids == null) return [];

    List<Future<Solution>> solutions = ids.map<Future<Solution>>((solutionId) {
      return _db
          .collection('solutions')
          .doc('$solutionId')
          .get()
          .then((solutionDoc) {
        return Solution.fromMap(
          id: solutionDoc.id,
          data: solutionDoc.data()!,
        );
      });
    }).toList();

    return Future.wait(solutions);
  }

  Future addSystem(System system) async {
    List<String> componentsIds = [];
    if (system.components != null)
      await Future.forEach<Component>(system.components!, (component) async {
        List<String> problemsIds = [];
        if (component.problems != null)
          await Future.forEach<Problem>(component.problems!, (problem) async {
            List<String> responsesIds = [];
            if (problem.userResponses != null)
              await Future.forEach<UserResponse>(problem.userResponses!,
                  (response) async {
                List<String> solutionsIds = [];
                if (response.solutions != null)
                  await Future.forEach<Solution>(response.solutions!,
                      (solution) async {
                    await _db
                        .collection('solutions')
                        .add(solution.toMap())
                        .then(
                            (solutionRef) => solutionsIds.add(solutionRef.id));
                  });
                await _db
                    .collection('userResponses')
                    .add(response.toMap(solutionsIds))
                    .then((responseRef) => responsesIds.add(responseRef.id));
              });
            await _db
                .collection('problems')
                .add(problem.toMap(responsesIds))
                .then((problemRef) => problemsIds.add(problemRef.id));
          });
        await _db
            .collection('components')
            .add(component.toMap(problemsIds))
            .then((componentsRef) {
          componentsIds.add(componentsRef.id);
        });
      });
    return _db.collection('systems').add(system.toMap(componentsIds));
  }
}
