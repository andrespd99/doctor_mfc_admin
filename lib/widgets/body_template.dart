import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/widgets/section_header.dart';
import 'package:flutter/material.dart';

class BodyTemplate extends StatefulWidget {
  final String title;
  final List<Widget> body;
  BodyTemplate({
    required this.title,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  _BodyTemplateState createState() => _BodyTemplateState();
}

class _BodyTemplateState extends State<BodyTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: kDefaultPadding * 4,
        right: kDefaultPadding * 4,
        top: kDefaultPadding * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: '${widget.title}'),
          SizedBox(height: kDefaultPadding),
          ...widget.body,
        ],
      ),
    );
  }
}
