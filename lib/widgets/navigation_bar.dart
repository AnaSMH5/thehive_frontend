import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/templates/movie_page.dart';
import 'package:frontend/widgets/auth_related_widgets/login_popup.dart';
import 'package:frontend/widgets/navigation_widget/nav_text_button.dart';
import 'package:frontend/widgets/auth_related_widgets/register_button.dart';
import 'package:frontend/widgets/root_page_controller.dart';

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
            bottom: BorderSide(
              color: theme.colorScheme.onPrimary,
              width: 2.0,
            )),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RootPage()),
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
                label: 'SIGN UP',
                onTap: () => showLoginPopUp(context),
              )
            ],
          ),
          NavTextButton(
              label: 'REGISTER NOW',
              onTap: () => RegisterButton().showRegisterDialog(context)),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavTextButton(
                  label: 'FILMS',
                  destination: const MoviePage())
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NavTextButton(
                label: 'NEWS',
                onTap: () => showLoginPopUp(context),
              ) // Change the destination
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(15.0);
}