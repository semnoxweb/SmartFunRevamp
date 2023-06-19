import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/instance_manager.dart';
import 'package:semnox/colors/colors.dart';
import 'package:semnox/core/domain/entities/card_details/card_details.dart';
import 'package:semnox/core/routes.dart';
import 'package:semnox/core/utils/dialogs.dart';
import 'package:semnox/core/widgets/mulish_text.dart';
import 'package:semnox/features/home/provider/cards_provider.dart';
import 'package:semnox/features/home/widgets/buy_new_card_button.dart';
import 'package:semnox/features/home/widgets/carousel_cards.dart';
import 'package:semnox/features/home/widgets/home_view_widgets/notification_button.dart';
import 'package:semnox/features/home/widgets/link_a_card.dart';
import 'package:semnox/features/home/widgets/recharge_card_details_button.dart';
import 'package:semnox/features/login/widgets/profile_picture.dart';
import 'package:semnox/features/login/widgets/quick_link_item.dart';
import 'package:semnox/features/membership_info/provider/membership_info_provider.dart';
import 'package:semnox/features/select_location/provider/select_location_provider.dart';
import 'package:semnox/features/splash/after_splash_screen.dart';
import 'package:semnox/features/splash/provider/splash_screen_notifier.dart';
import 'package:semnox_core/modules/customer/model/customer/customer_dto.dart';
import 'package:shimmer/shimmer.dart';

final promoImagesProvider = Provider<List<String>>((ref) {
  final cms = ref.watch(cmsProvider).value;
  final promos = cms?.cmsModulePages?.where((element) => element.displaySection == 'IMAGE').toList();
  return promos?.map((e) => e.contentURL).toList() ?? [];
});

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final user = Get.find<CustomerDTO>();
  CardDetails? cardDetails;

  int _cardIndex = -1;

  @override
  Widget build(BuildContext context) {
    final cardsWatch = ref.watch(CardsProviders.userCardsProvider);
    final promoImages = ref.watch(promoImagesProvider);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: const BoxDecoration(
                color: CustomColors.customLigthBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      ProfilePicture(customerDTO: user),
                      const SizedBox(width: 10.0),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user.profileDto?.firstName} ${user.profileDto?.lastName}',
                            style: const TextStyle(
                              color: CustomColors.customBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          ref.watch(membershipInfoProvider).when(
                                error: (_, __) => const MulishText(text: 'Error '),
                                loading: () => const ShimmerLoading(
                                  height: 10.0,
                                  width: 50,
                                ),
                                data: (data) {
                                  if (data.membershipId == -1) {
                                    return Container();
                                  }
                                  return MulishText(
                                    text: '${data.memberShipName}',
                                    fontWeight: FontWeight.bold,
                                  );
                                },
                              ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pushNamed(context, Routes.kSearch),
                        icon: const Icon(
                          Icons.search_outlined,
                          color: CustomColors.customBlue,
                        ),
                      ),
                      const NotificationsButton(),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: cardsWatch.when(
                      skipLoadingOnRefresh: false,
                      loading: () => const ShimmerLoading(height: 200),
                      error: (_, __) => const Center(
                        child: MulishText(text: 'No Cards found'),
                      ),
                      data: (data) {
                        return Column(
                          children: [
                            data.isNotEmpty
                                ? CarouselCards(
                                    cards: data,
                                    onCardChanged: (cardIndex) {
                                      setState(() {
                                        if (cardIndex != data.length) {
                                          cardDetails = data[cardIndex];
                                        }
                                        _cardIndex = cardIndex;
                                      });
                                    },
                                  )
                                : LinkACard(),
                            if (data.isNotEmpty && _cardIndex != data.length)
                              RechargeCardDetailsButton(
                                cardDetails: cardDetails ?? data.first,
                              )
                            else
                              const BuyNewCardButton(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 0,
              width: 0,
              child: Consumer(
                builder: (context, ref, child) {
                  return ref.watch(getAllSitesProvider).maybeWhen(
                        orElse: () => Container(),
                      );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        SplashScreenNotifier.getLanguageLabel('Quick Links'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                  cardsWatch.when(
                    error: (error, stackTrace) => Container(),
                    loading: () => const ShimmerLoading(height: 200.0),
                    data: (data) {
                      bool hasCard = data.isNotEmpty ? true : false;
                      String msgCardNoLink = SplashScreenNotifier.getLanguageLabel('No card is associated with customer, please link your card.');
                      return GridView(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          QuickLinkItem(
                            color: CustomColors.customYellow,
                            image: 'recharge',
                            text: 'Recharge',
                            onTap: () => hasCard
                                ? Navigator.pushNamed(context, Routes.kRechargePageCard)
                                : Dialogs.showMessageInfo(context, SplashScreenNotifier.getLanguageLabel('Recharge Card'), msgCardNoLink),
                          ),
                          QuickLinkItem(
                            color: CustomColors.customPink,
                            image: 'new_card',
                            text: 'New Card',
                            onTap: () => Navigator.pushNamed(context, Routes.kBuyACard),
                          ),
                          QuickLinkItem(
                            color: CustomColors.customLigthBlue,
                            image: 'activities',
                            text: 'Activities',
                            onTap: () =>
                                hasCard ? Navigator.pushNamed(context, Routes.kActivities) : Dialogs.showMessageInfo(context, SplashScreenNotifier.getLanguageLabel('Activities'), msgCardNoLink),
                          ),
                          QuickLinkItem(
                            color: CustomColors.customOrange,
                            image: 'lost_card',
                            text: 'Lost Card',
                            onTap: () =>
                                hasCard ? Navigator.pushNamed(context, Routes.kLostPageCard) : Dialogs.showMessageInfo(context, SplashScreenNotifier.getLanguageLabel('Lost Card'), msgCardNoLink),
                          ),
                          QuickLinkItem(
                            color: CustomColors.customGreen,
                            image: 'gameplays',
                            text: 'Game Plays',
                            onTap: () =>
                                hasCard ? Navigator.pushNamed(context, Routes.kGameplays) : Dialogs.showMessageInfo(context, SplashScreenNotifier.getLanguageLabel('Game Plays'), msgCardNoLink),
                          ),
                          QuickLinkItem(
                            color: CustomColors.customPurple,
                            image: 'transfer_credit',
                            text: 'Transfer Credit',
                            onTap: () =>
                                hasCard ? Navigator.pushNamed(context, Routes.kTransfers) : Dialogs.showMessageInfo(context, SplashScreenNotifier.getLanguageLabel('Transfer Credit'), msgCardNoLink),
                          ),
                        ],
                      );
                    },
                  ),
                  const MulishText(
                    text: "Today's Offers",
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                  Builder(
                    builder: (context) {
                      return CarouselSlider(
                        options: CarouselOptions(height: 200.0),
                        items: promoImages.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: CachedNetworkImage(
                                  imageUrl: i,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const MulishText(
                    text: 'More Actions',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                  GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      QuickLinkItem(
                        color: CustomColors.customPink,
                        image: 'new_card',
                        text: 'Link A Card',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Container(
                                  height: 245,
                                  padding: const EdgeInsets.all(10),
                                  child: LinkACard(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const QuickLinkItem(
                        color: CustomColors.customYellow,
                        image: 'tickets',
                        text: 'Tickets',
                      ),
                      const QuickLinkItem(
                        color: CustomColors.customOrange,
                        image: 'coupons',
                        text: 'Coupons',
                      ),
                      const QuickLinkItem(
                        color: CustomColors.customGreen,
                        image: 'events',
                        text: 'Events',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
    required this.height,
    this.width = double.infinity,
  });
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
