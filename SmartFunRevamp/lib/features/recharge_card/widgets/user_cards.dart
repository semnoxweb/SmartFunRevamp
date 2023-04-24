// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:infinite_carousel/infinite_carousel.dart';
// import 'package:intl/intl.dart';
// import 'package:semnox/colors/gradients.dart';
// import 'package:semnox/core/domain/entities/card_details/card_details.dart';
// import 'package:semnox/core/widgets/mulish_text.dart';
// import 'package:semnox/features/home/provider/cards_provider.dart';
// import 'package:semnox/core/utils/extensions.dart';

// class UserCards extends StatefulWidget {
//   const UserCards({Key? key, required this.onCardSelected}) : super(key: key);
//   final Function(CardDetails) onCardSelected;

//   @override
//   State<UserCards> createState() => _UserCardsState();
// }

// class _UserCardsState extends State<UserCards> {
//   double cardToRecharge = 0;
//   CardDetails? selectedCard;
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, child) {
//         return ref.watch(CardsProviders.userCardsProvider).maybeWhen(
//               orElse: () => Container(),
//               loading: () => const CircularProgressIndicator(),
//               data: (data) {
//                 if (selectedCard == null) {
//                   selectedCard = data[0];
//                   widget.onCardSelected(selectedCard!);
//                 }
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.25,
//                       child: InfiniteCarousel.builder(
//                         itemCount: data.length,
//                         itemExtent: MediaQuery.of(context).size.width,
//                         center: true,
//                         anchor: 0.5,
//                         velocityFactor: 0.2,
//                         onIndexChanged: (index) {
//                           widget.onCardSelected(data[index]);
//                           setState(() {
//                             cardToRecharge = index.toDouble();
//                           });
//                         },
//                         axisDirection: Axis.horizontal,
//                         loop: false,
//                         itemBuilder: (context, itemIndex, realIndex) {
//                           final card = data[itemIndex];
//                           final formatter = DateFormat('dd MMM yyyy');
//                           late final validPeriod = card.expiryDate.isNullOrEmpty()
//                               ? formatter.format(card.issueDate ?? DateTime.now())
//                               : '${formatter.format(card.issueDate ?? DateTime.now())} - ${formatter.format(DateTime.parse(card.expiryDate.toString()))}';
//                           return Container(
//                             margin: const EdgeInsets.all(10.0),
//                             padding: const EdgeInsets.only(left: 15, top: 0, right: 10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20.0),
//                               gradient: CustomGradients.linearGradient,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Row(children: [
//                                           MulishText(
//                                             text: card.accountNumber ?? '',
//                                             fontColor: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 18,
//                                           ),
//                                         ]),
//                                         const SizedBox(width: 10.0),
//                                         Row(children: [
//                                           !card.accountIdentifier.isNullOrEmpty()
//                                               ? MulishText(
//                                                   text: card.accountIdentifier ?? '',
//                                                   fontColor: Colors.white,
//                                                 )
//                                               : const MulishText(
//                                                   text: '+Add Nickname',
//                                                   textDecoration: TextDecoration.underline,
//                                                   fontColor: Colors.white,
//                                                   fontSize: 12.0,
//                                                 ),
//                                         ]),
//                                       ],
//                                     ),
//                                     Image.asset(
//                                       'assets/home/QR.png',
//                                       height: 42,
//                                     )
//                                   ],
//                                 ),
//                                 OutlinedButton(
//                                   onPressed: () {},
//                                   style: OutlinedButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12.0),
//                                     ),
//                                     side: const BorderSide(
//                                       width: 1.5,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   child: const MulishText(
//                                     text: 'Get Balance',
//                                     fontColor: Colors.white,
//                                   ),
//                                 ),
//                                 MulishText(
//                                   text: validPeriod,
//                                   fontColor: Colors.white,
//                                 )
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             );
//       },
//     );
//   }
// }
