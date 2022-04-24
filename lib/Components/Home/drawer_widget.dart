// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
class DrawerWidget extends StatelessWidget {
  final ValueChanged<DrawerItem> onSelectedItem;
  const DrawerWidget({
    required this.onSelectedItem
});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30,left: 10,right: 0),
          child: Container(
            width: 220,
            child: Column(
              children: [
                CircleAvatar(
                    backgroundImage:AssetImage('asset/images/profile.png',
                ),
                  radius: 70,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Full Name",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 5,
                  ),
                ),
                buildDrawerItems(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildDrawerItems(BuildContext context){
    return Column(
        children: DrawerItems.all
            .map(
              (item) => ListTile(
                contentPadding: EdgeInsets.only(top: 8,bottom: 8,left: 5),
                leading: Icon(item.icon,color: Colors.white,size: 30),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: (){
                  onSelectedItem(item);
                },

              ),
        ).toList(),
    );
  }
}
class DrawerItem{
  final String title;
  final IconData icon;
  const DrawerItem({required this.title, required this.icon});
}
class DrawerItems{
  static const home = DrawerItem(title: "Home", icon: Icons.home);
  static const profile = DrawerItem(title: "Profile", icon: Icons.account_circle);
  static const summary = DrawerItem(title: "Summary", icon: Icons.summarize);
  static const externalCamera = DrawerItem(title: "External Camera", icon: Icons.videocam);
  static const setting = DrawerItem(title: "Setting", icon: Icons.settings);
  static const logout = DrawerItem(title: "Log Out", icon: Icons.logout);

  static final List<DrawerItem> all = [
    home,
    profile,
    summary,
    externalCamera,
    setting,
    logout
  ];
}
