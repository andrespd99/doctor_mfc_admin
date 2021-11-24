import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/widgets/section_header.dart';
import 'package:flutter/material.dart';

class BodyTemplate extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<Widget> body;

  BodyTemplate({
    required this.title,
    this.subtitle,
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
      color: kBackgroundColor,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 800,
            ),
            padding: EdgeInsets.only(
              left: kDefaultPadding * 4,
              right: kDefaultPadding * 4,
              top: kDefaultPadding * 2,
              bottom: kDefaultPadding * 3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (Navigator.canPop(context)) ? goBackButton() : Container(),
                    SizedBox(width: kDefaultPadding / 3),
                    SectionHeader(
                      title: '${widget.title}',
                      subtitle: widget.subtitle,
                    ),
                  ],
                ),
                SizedBox(height: kDefaultPadding * 2.5),
                ...widget.body,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget goBackButton() {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(Icons.arrow_back_ios),
    );
  }
}
