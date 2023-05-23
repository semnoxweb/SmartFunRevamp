import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:semnox/colors/colors.dart';
import 'package:semnox/colors/gradients.dart';
import 'package:semnox/core/domain/entities/membership/membership_info.dart';
import 'package:semnox/core/routes.dart';
import 'package:semnox/core/utils/extensions.dart';
import 'package:semnox/core/widgets/mulish_text.dart';
import 'package:semnox/features/home/provider/cards_provider.dart';
import 'package:semnox/features/membership_info/widgets/membership_options.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class CurrentMembershipTier extends StatelessWidget {
  const CurrentMembershipTier({super.key, required this.userMembershipInfo});
  final MembershipInfo? userMembershipInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 75, bottom: 10.0, right: 10.0, left: 10.0),
      height: MediaQuery.of(context).size.height * 0.55,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: const GradientBoxBorder(
          gradient: CustomGradients.verticalGoldenGradient,
          width: 1,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: CustomGradients.verticalGoldenGradient,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MulishText(
                  text: '${userMembershipInfo?.memberShipName}',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MulishText(
                      text: 'Since ${userMembershipInfo?.membershipValidity.formatDate('dd MMM yyyy')}',
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(width: 10.0),
                    const MulishText(
                      text: 'More >>',
                      fontWeight: FontWeight.bold,
                      fontColor: CustomColors.hardOrange,
                      textDecoration: TextDecoration.underline,
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: -75,
            height: 150,
            child: Image.asset(
              'assets/membership/gold.png',
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 125,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                          border: const GradientBoxBorder(
                            gradient: CustomGradients.goldenGradient,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const MulishText(
                              text: 'Loyalty Points Earned',
                              fontWeight: FontWeight.w600,
                            ),
                            MulishText(
                              text: '${userMembershipInfo?.membershipTotalPoints?.toInt()}',
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                          border: const GradientBoxBorder(
                            gradient: CustomGradients.goldenGradient,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const MulishText(
                              text: 'Balance',
                              fontWeight: FontWeight.w600,
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final points = ref.watch(CardsProviders.loyaltyPointsBalanceProvider);
                                return MulishText(
                                  text: '$points',
                                  fontWeight: FontWeight.bold,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                  ],
                ),
                MembershipOptions(
                  color: const Color(0xFFD0D5FF),
                  title: 'Loyalty Points Details',
                  svgImage: 'assets/membership/loyalty_points.svg',
                  onTap: () => Navigator.pushNamed(context, Routes.kLoyaltyPointsDetails),
                ),
                MembershipOptions(
                  color: const Color(0xFFCFF8FF),
                  title: 'Membership Rewards',
                  svgImage: 'assets/membership/membership_rewards.svg',
                  onTap: () => Navigator.pushNamed(context, Routes.kMembershipRewards),
                ),
                MembershipOptions(
                  color: const Color(0xFFD1FFD0),
                  title: 'Membership F&Q',
                  svgImage: 'assets/membership/faq.svg',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
