import 'package:doctor_mfc_admin/constants.dart';

import 'package:doctor_mfc_admin/services/page_change_service.dart';

import 'package:doctor_mfc_admin/src/manage_systems_page.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/green_elevated_button.dart';
import 'package:doctor_mfc_admin/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BodyTemplate(
      title: 'Home',
      body: [
        shortcutButtons(),
        SizedBox(height: kDefaultPadding * 3),
        SectionHeader(
          title: 'Update requests',
          subtitle: 'Click any to review',
        ),
      ],
    );
  }

  Wrap shortcutButtons() {
    return Wrap(
      direction: Axis.horizontal,
      runSpacing: kDefaultPadding,
      spacing: kDefaultPadding,
      children: [
        shortcutButton(
          onPressed: () =>
              Provider.of<PageChangeService>(context, listen: false)
                  .changePage(ManageSystemsPage()),
          title: 'Manage systems',
        ),
        shortcutButton(
          onPressed: () {},
          title: 'Add system',
        ),
      ],
    );
  }

  Widget shortcutButton({required Function onPressed, required String title}) {
    return GreenElevatedButton(
      onPressed: () => onPressed(),
      child: Text('$title'),
    );
  }
}
