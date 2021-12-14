import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/database.dart';

import 'package:doctor_mfc_admin/services/global_values.dart';
import 'package:doctor_mfc_admin/services/test/test_db.dart';

import 'package:doctor_mfc_admin/src/add_system_page.dart';
import 'package:doctor_mfc_admin/src/system_details_page.dart';
import 'package:doctor_mfc_admin/src/test/test_system_details_page.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/custom_card.dart';
import 'package:doctor_mfc_admin/widgets/custom_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/green_elevated_button.dart';
import 'package:flutter/material.dart';

class TestManageSystemsPage extends StatefulWidget {
  TestManageSystemsPage({Key? key}) : super(key: key);

  @override
  _TestManageSystemsPageState createState() => _TestManageSystemsPageState();
}

class _TestManageSystemsPageState extends State<TestManageSystemsPage> {
  List<String> brands = [];
  List<String> systemTypes = [];

  @override
  Widget build(BuildContext context) {
    return BodyTemplate(
      title: 'Manage systems',
      body: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a system',
                ),
              ),
            ),
            SizedBox(width: kDefaultPadding / 2),
            addSystemButton(),
          ],
        ),
        SizedBox(height: kDefaultPadding * 2),
        content(),
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
      itemCount: DBTest().systems.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        System system = DBTest().systems[i];

        return Align(
          alignment: Alignment.centerLeft,
          child: CustomCard(
            title: '${system.brand} ${system.model}',
            body: [
              Text('${system.components.length} components'),
              SizedBox(height: kDefaultPadding / 4),
              Text('${system.knownProblems.length} known problems'),
              SizedBox(height: kDefaultPadding / 4),
              Text('${system.solutions.length} solutions'),
            ],
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => TestSystemDetailsPage(system))),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: kDefaultPadding * 1.5),
    );
  }
}
