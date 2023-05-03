import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:semnox/colors/colors.dart';
import 'package:semnox/core/routes.dart';
import 'package:semnox/core/utils/extensions.dart';
import 'package:semnox/core/widgets/mulish_text.dart';
import 'package:semnox/features/notifications/provider/notifications_provider.dart';
import 'package:badges/badges.dart' as badges;

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(NotificationsProvider.notificationsStateProvider).maybeWhen(
              orElse: () => Container(),
              inProgress: () => const Icon(
                Icons.notifications_none_outlined,
                color: CustomColors.customBlue,
              ),
              success: (data) {
                if (data.isEmpty) {
                  return InkWell(
                    child: const Icon(
                      Icons.notifications_none_outlined,
                      color: CustomColors.customBlue,
                    ),
                    onTap: () => Navigator.pushNamed(context, Routes.kNotifications),
                  );
                }
                return badges.Badge(
                  badgeAnimation: const badges.BadgeAnimation.scale(),
                  badgeContent: MulishText(
                    text: data.countItems(),
                    fontColor: Colors.white,
                  ),
                  child: InkWell(
                    child: const Icon(
                      Icons.notifications_none_outlined,
                      color: CustomColors.customBlue,
                    ),
                    onTap: () => Navigator.pushNamed(context, Routes.kNotifications),
                  ),
                );
              },
              error: (error) => Container(),
            );
      },
    );
  }
}