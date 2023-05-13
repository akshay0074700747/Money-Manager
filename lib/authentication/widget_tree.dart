
import 'package:flutter/widgets.dart';
import 'package:money_manager/authentication/auth_screen.dart';
import 'package:money_manager/authentication/authservice.dart';
import 'package:money_manager/local_authentication/figerprint_page.dart';
import 'package:money_manager/main.dart';


class widget_tree extends StatefulWidget {
  const widget_tree({super.key});

  @override
  State<widget_tree> createState() => _widget_treeState();
}

class _widget_treeState extends State<widget_tree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authservice().notifycurrentuserstatechange,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Fingerprintpage();
        } else {
          return authentication_screen();
        }
      },
    );
  }
}