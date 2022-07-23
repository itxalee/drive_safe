// ignore_for_file: prefer_const_constructors, unused_element, avoid_print, dead_code, unnecessary_const
import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  final ValueChanged<AdminDrawerItem> onSelectedItem;
  const AdminDrawer({required this.onSelectedItem});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 10, right: 0),
          child: SizedBox(
            width: 220,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Admin',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: SizedBox(
                      height: 1,
                      width: size.width,
                      child: const DecoratedBox(
                          decoration: BoxDecoration(
                        color: Colors.white,
                      ))),
                ),
                buildAdminDrawerItems(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAdminDrawerItems(BuildContext context) {
    return Column(
      children: AdminDrawerItems.all
          .map(
            (item) => ListTile(
              contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5),
              leading: Icon(item.icon, color: Colors.white, size: 30),
              title: Text(
                item.title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                onSelectedItem(item);
              },
            ),
          )
          .toList(),
    );
  }
}

class AdminDrawerItem {
  final String title;
  final IconData icon;
  const AdminDrawerItem({required this.title, required this.icon});
}

class AdminDrawerItems {
  static const home =
      AdminDrawerItem(title: "Dashboard", icon: Icons.dashboard);
  static const deleteUsers =
      AdminDrawerItem(title: "Delete Users", icon: Icons.delete);

  static const summary =
      AdminDrawerItem(title: "Summary", icon: Icons.summarize);
  static const pdfReport =
      AdminDrawerItem(title: "PDF Report", icon: Icons.picture_as_pdf);
  static const logout = AdminDrawerItem(title: "Log Out", icon: Icons.logout);

  static final List<AdminDrawerItem> all = [
    home,
    deleteUsers,
    summary,
    pdfReport,
    logout,
  ];
}
