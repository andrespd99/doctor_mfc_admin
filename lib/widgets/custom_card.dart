import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/src/system_details_page.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final List<Widget> body;
  final Function() onPressed;

  CustomCard({
    required this.title,
    required this.body,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      color: Colors.black.withOpacity(0.05),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title(),
              SizedBox(height: kDefaultPadding / 2),
              ...widget.body,
            ],
          ),
          Spacer(),
          forwardButton()
        ],
      ),
    );
  }

  IconButton forwardButton() {
    return IconButton(
      onPressed: () => widget.onPressed(),
      icon: Icon(
        Icons.arrow_forward_ios,
        color: Colors.black38,
      ),
    );
  }

  Text title() {
    return Text(
      '${widget.title}',
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
