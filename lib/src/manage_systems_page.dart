import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/green_elevated_button.dart';
import 'package:flutter/material.dart';

class ManageSystemsPage extends StatefulWidget {
  ManageSystemsPage({Key? key}) : super(key: key);

  @override
  _ManageSystemsPageState createState() => _ManageSystemsPageState();
}

class _ManageSystemsPageState extends State<ManageSystemsPage> {
  List<String> types = ['Handhelds', 'Printers', 'Modems and Routers'];
  List<List<String>> devices = [
    [
      'Zebra TC51',
      'Zebra TC74',
    ],
    [
      'HP LasetJet P1122w',
    ],
    [
      'Cisco M52',
    ],
  ];

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
            GreenElevatedButton(
              onPressed: () {},
              child: Text('Add new system'),
            ),
          ],
        ),
        SizedBox(height: kDefaultPadding * 2),
        ListView.separated(
          shrinkWrap: true,
          itemCount: types.length,
          itemBuilder: (context, i) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${types[i]}',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: devices[i].length,
                  itemBuilder: (context, j) {
                    return Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${devices[i][j]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: kDefaultPadding / 2),
                            Text('4 components'),
                          ],
                        ),
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
              SizedBox(height: kDefaultPadding),
        ),
      ],
    );
  }
}
