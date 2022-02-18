import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/system.dart';
import 'package:doctor_mfc_admin/src/system_details_page.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<Widget> body;
  final Function() onPressed;
  final bool showDeleteButton;
  final Function()? onDelete;

  CustomCard({
    required this.title,
    this.subtitle,
    required this.body,
    required this.onPressed,
    this.showDeleteButton = false,
    this.onDelete,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        color: Colors.black.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title(),
                SizedBox(height: kDefaultPadding / 4),
                subtitle(),
                SizedBox(height: kDefaultPadding / 2),
                ...widget.body,
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: (widget.showDeleteButton) ? deleteButton() : forwardButton(),
          ),
        ],
      ),
    );
  }

  TextButton deleteButton() {
    return TextButton(
      onPressed: (widget.onDelete != null) ? () => widget.onDelete!() : null,
      child: Text('Delete'),
      style: TextButton.styleFrom(primary: kAccentColor),
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

  Widget title() {
    return Text(
      '${widget.title}',
      style: Theme.of(context).textTheme.headline6,
    );
  }

  Widget subtitle() {
    if (widget.subtitle != null)
      return Text(
        '${widget.subtitle}',
        style: Theme.of(context)
            .textTheme
            .bodyText2
            ?.copyWith(color: kFontBlack.withOpacity(0.5)),
      );
    else
      return Container();
  }
}
