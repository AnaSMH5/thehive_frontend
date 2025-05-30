import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/widgets/login_popup.dart';
import 'package:frontend/widgets/nav_text_button.dart';
import 'package:frontend/templates/login_page.dart';
import 'package:frontend/templates/home_page.dart';

class CustomNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 10),
      decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          border: Border(
              bottom:
                  BorderSide(color: theme.colorScheme.onPrimary, width: 2.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            child: SvgPicture.asset(
              'assets/icons/logo+title.svg',
              height: 40,
            ),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavTextButton(
                  label: 'ENTER',
                  onTap: () => showLoginPopUp(context),
                  width: 61)
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavTextButton(
                  label: 'FILMS',
                  destination: const LoginPage()) // Change the destination
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavTextButton(
                  label: 'NEWS',
                  destination: const LoginPage()) // Change the destination
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(15.0);
}
