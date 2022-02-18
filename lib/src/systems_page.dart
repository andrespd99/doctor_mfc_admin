import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/current_system_selected_service.dart';
import 'package:doctor_mfc_admin/services/database.dart';

import 'package:doctor_mfc_admin/services/global_values.dart';

import 'package:doctor_mfc_admin/src/add_system_page.dart';
import 'package:doctor_mfc_admin/src/system_details_page.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/custom_card.dart';
import 'package:doctor_mfc_admin/widgets/custom_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/green_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SystemsPage extends StatefulWidget {
  SystemsPage({Key? key}) : super(key: key);

  @override
  _SystemsPageState createState() => _SystemsPageState();
}

class _SystemsPageState extends State<SystemsPage> {
  List<String> brands = [];
  List<String> systemTypes = [];
  late Map<String, int> lengths;

  @override
  Widget build(BuildContext context) {
    return BodyTemplate(
      title: 'Manage systems',
      body: [
        addSystemButton(),
        // TODO: Add searcher
        // Row(
        //   children: [
        //     Container(
        //       width: MediaQuery.of(context).size.width * 0.3,
        //       child: TextField(
        //         decoration: InputDecoration(
        //           hintText: 'Search for a system',
        //         ),
        //       ),
        //     ),
        //     SizedBox(width: kDefaultPadding / 2),
        //   ],
        // ),
        SizedBox(height: kDefaultPadding * 2),
        FutureBuilder<Map<String, dynamic>>(
            future: GlobalValues().getGlobalValues(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Set global values.
                brands = List.from(snapshot.data!['brands'] ?? []);
                systemTypes = List.from(snapshot.data!['systemTypes'] ?? []);

                return content();
              } else
                return CustomLoadingIndicator();
            }),
      ],
    );
  }

  GreenElevatedButton addSystemButton() {
    return GreenElevatedButton(
      child: Text('Add new system'),
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => AddSystemPage())),
    );
  }

  Widget content() {
    final database = Database();

    // Types List
    return ListView.separated(
      shrinkWrap: true,
      itemCount: systemTypes.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        String type = systemTypes[i];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device TYPE header.
            Text(
              '$type',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: kDefaultPadding * 0.8),
            // List of devices of this TYPE.
            StreamBuilder<QuerySnapshot<System>>(
                stream: database.getSystemsByTypeSnapshots(type),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Get List of Systems from query snapshots.
                    List<System> systems =
                        snapshot.data!.docs.map((e) => e.data()).toList();

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: systems.length,
                      itemBuilder: (context, j) {
                        System system = systems[j];

                        return Align(
                          alignment: Alignment.centerLeft,
                          child: CustomCard(
                            title: '${system.brand} ${system.description}',
                            body: [
                              Text('${system.problems.length} known problems'),
                              SizedBox(height: kDefaultPadding / 4),
                              Text('${system.solutions.length} solutions'),
                            ],
                            onPressed: () => onSystemPressed(system),
                          ),
                        );
                      },
                      separatorBuilder: (context, i) =>
                          SizedBox(height: kDefaultPadding / 2),
                    );
                  } else
                    return CustomLoadingIndicator();
                })
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: kDefaultPadding * 1.5),
    );
  }

  Future<dynamic> onSystemPressed(System system) {
    Provider.of<CurrentSystemSelectedService>(context, listen: false)
        .selectSystem(system);

    return Navigator.push(
        context, MaterialPageRoute(builder: (_) => SystemDetailsPage(system)));
  }
}
