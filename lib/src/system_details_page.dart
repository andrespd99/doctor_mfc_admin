import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/component.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/services/test_systems_service.dart';
import 'package:doctor_mfc_admin/widgets/body_template.dart';
import 'package:doctor_mfc_admin/widgets/custom_card.dart';

import 'package:doctor_mfc_admin/widgets/section_subheader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SystemDetailsPage extends StatefulWidget {
  final System system;

  SystemDetailsPage(
    this.system, {
    Key? key,
  }) : super(key: key);

  @override
  _SystemDetailsPageState createState() => _SystemDetailsPageState();
}

class _SystemDetailsPageState extends State<SystemDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BodyTemplate(
      title: 'System name',
      body: [
        SectionSubheader('System information'),
        SizedBox(height: kDefaultPadding),
        Row(
          children: [
            attributeTextField(),
            SizedBox(width: kDefaultPadding),
            attributeTextField(),
            SizedBox(width: kDefaultPadding),
            attributeTextField(),
          ],
        ),
        SizedBox(height: kDefaultPadding * 2),
        SectionSubheader('Components'),
        SizedBox(height: kDefaultPadding),
        componentsList()
      ],
    );
  }

  StatelessWidget componentsList() {
    if (widget.system.components != null) {
      List<Component> components = widget.system.components!;

      return ListView.separated(
        shrinkWrap: true,
        itemCount: components.length,
        itemBuilder: (context, i) {
          Component component = components[i];

          return Align(
            alignment: Alignment.centerLeft,
            child: CustomCard(
              title: component.description,
              body: [],
              onPressed: () {},
            ),
          );
        },
        separatorBuilder: (context, i) {
          return SizedBox(height: kDefaultPadding / 2);
        },
      );
    } else
      return Text('None', style: TextStyle(color: Colors.grey));
  }

  Widget attributeTextField() {
    return Flexible(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attribute',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: kDefaultPadding / 3),
            TextField(),
          ],
        ),
      ),
    );
  }
}
