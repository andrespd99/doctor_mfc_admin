import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/models/system_type.dart';
import 'package:doctor_mfc_admin/services/test_systems_service.dart';
import 'package:doctor_mfc_admin/src/add_system_page.dart';
import 'package:doctor_mfc_admin/src/system_details_page.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/custom_card.dart';
import 'package:doctor_mfc_admin/widgets/green_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageSystemsPage extends StatefulWidget {
  ManageSystemsPage({Key? key}) : super(key: key);

  @override
  _ManageSystemsPageState createState() => _ManageSystemsPageState();
}

class _ManageSystemsPageState extends State<ManageSystemsPage> {
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
    TestSystemsService systemsService =
        Provider.of<TestSystemsService>(context);

    // Types List
    return ListView.separated(
      shrinkWrap: true,
      itemCount: systemsService.types.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        SystemType type = systemsService.types[i];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device TYPE header.
            Text(
              '${type.description}',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: kDefaultPadding * 0.8),
            // List of devices of this TYPE.
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: systemsService.getSystemsByType(type.id).length,
              itemBuilder: (context, j) {
                System system = systemsService.getSystemsByType(type.id)[j];
                return Align(
                  alignment: Alignment.centerLeft,
                  child: CustomCard(
                    title: '${system.brand} ${system.model}',
                    body: [
                      Text('${system.knownProblemsCount()} components'),
                      SizedBox(height: kDefaultPadding / 2),
                      Text('${system.solutionsCount()} solutions'),
                    ],
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SystemDetailsPage(system))),
                  ),
                );
              },
              separatorBuilder: (context, i) =>
                  SizedBox(height: kDefaultPadding / 2),
            )
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: kDefaultPadding * 1.5),
    );
  }
}
