import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/drawer_item.dart';
import 'package:doctor_mfc_admin/models/enums/attachment_type.dart';
import 'package:doctor_mfc_admin/services/mfc_auth_service.dart';
import 'package:doctor_mfc_admin/services/page_change_service.dart';
import 'package:doctor_mfc_admin/src/files_page.dart';
import 'package:doctor_mfc_admin/src/home_page.dart';
import 'package:doctor_mfc_admin/src/systems_page.dart';
import 'package:doctor_mfc_admin/src/user_requests_page.dart';
import 'package:doctor_mfc_admin/src/users_page.dart';
import 'package:doctor_mfc_admin/widgets/custom_progress_indicator.dart';
import 'package:doctor_mfc_admin/widgets/future_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/powered_by_takeoff.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  IndexPage({
    Key? key,
  }) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin {
  // Drawer items.
  final Map<int, DrawerItem> itemsMap = Map.from(
    {
      0: DrawerItem(
        title: 'User requests',
        child: UserRequestsPage(),
      ),
      1: DrawerItem(
        title: 'Systems',
        child: SystemsPage(),
      ),
      2: DrawerItem(
        title: 'Documentation',
        child: FilesPage(
          type: AttachmentType.DOCUMENTATION,
          key: UniqueKey(),
        ),
      ),
      3: DrawerItem(
        title: 'How-to guides',
        child: FilesPage(
          type: AttachmentType.GUIDE,
          key: UniqueKey(),
        ),
      ),
      4: DrawerItem(
        title: 'Users',
        child: UsersPage(),
      ),
    },
  );

  // Selected drawer item index.
  late int selectedIndex = 0;

  // Used to keep drawer state.
  late bool drawerIsOpen = false;

  Duration drawerDuration = Duration(milliseconds: 300);

/* --------------------------- Drawer dimensions. --------------------------- */
  double drawerWidth = 260.0;
  double horizontalPadding = kDefaultPadding / 3;
  double drawerIconSize = 28;

  double closedDrawerWidth() => drawerIconSize + (horizontalPadding + 8) * 2;

/* -------------------------------------------------------------------------- */

  /// Drawer offset when transitioning from open to closed.
  Offset get drawerOffset {
    double closedDrawerXOffset =
        (closedDrawerWidth() - drawerWidth) * (1 - animation.value);

    return Offset(closedDrawerXOffset, 0);
  }

/* --------------------- Animation controller and curve. -------------------- */
  late final animationController = AnimationController(
    vsync: this,
    duration: drawerDuration,
  );

  late final animation = CurvedAnimation(
    parent: animationController,
    curve: Curves.easeInOutQuart,
  );
/* -------------------------------------------------------------------------- */

  Widget get selectedIndexPage => itemsMap[selectedIndex]!.child;

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<PageChangeService>(context, listen: false)
        .changePage(selectedIndexPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: bodyBuilder(),
        ),
        drawerBuilder(),
      ],
    );
  }

  Widget bodyBuilder() {
    double bodyWidthDrawerClosed =
        MediaQuery.of(context).size.width - closedDrawerWidth();

    double bodyWidthDrawerOpen =
        MediaQuery.of(context).size.width - drawerWidth;

    return AnimatedContainer(
      duration: drawerDuration,
      curve: Curves.easeInOutQuart,
      width: (drawerIsOpen) ? bodyWidthDrawerOpen : bodyWidthDrawerClosed,
      child: StreamBuilder<Widget>(
        initialData: selectedIndexPage,
        stream: Provider.of<PageChangeService>(context).currentPage,
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            Widget body = snapshot.data!;

            return body;
          } else {
            return CustomProgressIndicator();
          }
        },
      ),
    );
  }

  AnimatedBuilder drawerBuilder() {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: drawerOffset,
          child: child,
        );
      },
      child: drawer(),
    );
  }

  Container drawer() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: kDefaultPadding,
      ),
      width: drawerWidth,
      decoration: BoxDecoration(gradient: kRadialPrimaryBg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          menuButton(),
          Spacer(),
          ...drawerItems(),
        ],
      ),
    );
  }

  List<Widget> drawerItems() {
    return [
      // List of items.
      Container(
        padding: EdgeInsets.only(left: kDefaultPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              itemCount: itemsMap.length,
              itemBuilder: (context, i) => drawerItem(i),
              separatorBuilder: (context, i) =>
                  SizedBox(height: kDefaultPadding * 1.5),
            ),
            SizedBox(height: kDefaultPadding * 2),
            TextButton(
              child: Text(
                'Log out',
                style: TextStyle(
                  shadows: [
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 10,
                      color: Colors.black26,
                    )
                  ],
                ),
              ),
              style: TextButton.styleFrom(primary: Colors.red),
              onPressed: () => futureLoadingIndicator(
                context,
                Provider.of<MFCAuthService>(context, listen: false).signOut(),
              ),
            ),
          ],
        ),
      ),

      Spacer(flex: 2),
      // Takeoff logo.
      Center(
        child: PoweredByTakeoffWidget(
          height: 50,
        ),
      ),
    ];
  }

  Widget menuButton() {
    return Row(
      children: [
        Spacer(),
        IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            color: kFontWhite,
            progress: animation,
            size: drawerIconSize,
          ),
          onPressed: () => toggleDrawer(),
        ),
      ],
    );
  }

  Widget drawerItem(int index) {
    final style = Theme.of(context).textTheme.button?.apply(color: kFontWhite);

    double itemPadding = kDefaultPadding / 3;

    if (selectedIndex == index) {
      return Row(children: [
        SizedBox(width: itemPadding),
        CircleAvatar(
          radius: 4,
          backgroundColor: kSecondaryLightColor,
        ),
        SizedBox(width: kDefaultPadding / 2),
        TextButton(
          onPressed: () {
            Provider.of<PageChangeService>(context, listen: false)
                .changePage(selectedIndexPage);
          },
          child: Text(
            itemsMap[index]!.title,
            style: style?.apply(
              color: kSelectedDrawerItem,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: itemPadding),
          ),
        ),
      ]);
    } else {
      return Row(
        children: [
          TextButton(
            onPressed: () {
              this.selectedIndex = index;

              setState(() {});

              Provider.of<PageChangeService>(context, listen: false)
                  .changePage(selectedIndexPage);
            },
            child: Text(
              itemsMap[index]!.title,
              style: style,
            ),
            style: TextButton.styleFrom(
              alignment: Alignment.centerLeft,
            ),
          ),
        ],
      );
    }
  }

  /// Open and close drawer.
  void toggleDrawer() {
    if (drawerIsOpen)
      animationController.reverse();
    else
      animationController.forward();

    setState(() {
      drawerIsOpen = !drawerIsOpen;
    });
  }
}
