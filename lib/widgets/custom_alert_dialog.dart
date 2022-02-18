import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/widgets/section_header.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<Widget> body;
  final Function()? onFinish;
  final String? finishButtonTitle;
  final bool showBackButton;
  final bool isButtonEnabled;

  /// If `onFinish` is not null, `finishButtonTitle` cannot be null either.
  CustomAlertDialog({
    required this.title,
    required this.body,
    this.onFinish,
    this.finishButtonTitle,
    this.subtitle,
    this.showBackButton = true,
    this.isButtonEnabled = true,
    Key? key,
  }) : super(key: key);

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.85,
        padding: EdgeInsets.all(kDefaultPadding * 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heading(),
                SizedBox(height: kDefaultPadding * 2),
                ...widget.body,
                // Spacer(),
                SizedBox(height: kDefaultPadding / 2),
              ],
            ),
            finishButton(),
          ],
        ),
      ),
    );
  }

  Widget finishButton() {
    if (widget.finishButtonTitle == null)
      return Container();
    else
      return Positioned(
        bottom: 0,
        right: 0,
        child: ElevatedButton(
          child: Text('${widget.finishButtonTitle!}'),
          onPressed: widget.isButtonEnabled ? () => widget.onFinish!() : null,
          style: ElevatedButton.styleFrom(
            visualDensity: VisualDensity.compact,
          ),
        ),
      );
  }

  Row heading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (widget.showBackButton)
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios),
              )
            : Container(),
        Expanded(
          child: SectionHeader(
            title: '${widget.title}',
            subtitle: (widget.subtitle != null) ? '${widget.subtitle}' : null,
          ),
        ),
        // Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        )
      ],
    );
  }
}
