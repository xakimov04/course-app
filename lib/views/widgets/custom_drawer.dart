import 'dart:math';

import 'package:flutter/material.dart';

import 'package:online_shop/views/screens/home_page.dart';
import 'package:online_shop/views/screens/settings_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage("images/chatbg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("images/mardon.png"),
          ),
          SizedBox(height: 10),
          Text("Hakimov Mardon",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 5),
          Text(
            "+998 97 421 0412",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class SpiderDrawer extends StatelessWidget {
  const SpiderDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerWidget(),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(AppLocalizations.of(context)!.appHome),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(AppLocalizations.of(context)!.contact),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: Text(AppLocalizations.of(context)!.calls),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.radar_outlined),
            title:  Text(AppLocalizations.of(context)!.people),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title:  Text(AppLocalizations.of(context)!.save),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(AppLocalizations.of(context)!.settings),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.person_add_outlined),
            title:  Text(AppLocalizations.of(context)!.invite),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title:  Text(AppLocalizations.of(context)!.features),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
