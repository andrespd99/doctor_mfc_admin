import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/widgets/section_header.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final List<Widget> body;
  final Function() onFinish;
  final String finishButtonTitle;
  final bool showBackButton;
  final bool isButtonEnabled;

  CustomAlertDialog({
    required this.title,
    required this.body,
    required this.onFinish,
    required this.finishButtonTitle,
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
      child: SingleChildScrollView(
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.85,
          padding: EdgeInsets.all(kDefaultPadding * 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading(),
              SizedBox(height: kDefaultPadding * 2),
              ...widget.body,
              Spacer(),
              SizedBox(height: kDefaultPadding / 2),
              finishButton(),
            ],
          ),
        ),
      ),
    );
  }

  Align finishButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        child: Text('${widget.finishButtonTitle}'),
        onPressed: widget.isButtonEnabled ? () => widget.onFinish() : null,
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
