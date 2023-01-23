import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:semnox/colors/colors.dart';
import 'package:semnox/colors/gradients.dart';

enum CardValue { silver, gold, platinum }

extension CardValueExtension on CardValue {
  String get name {
    switch (this) {
      case CardValue.silver:
        return 'SILVER';
      case CardValue.gold:
        return 'GOLD';
      case CardValue.platinum:
        return 'PLATINUM';
      default:
        return '';
    }
  }

  Gradient get colorGradient {
    switch (this) {
      case CardValue.silver:
        return CustomGradients.silverCircularGradient;
      case CardValue.gold:
        return CustomGradients.goldenCircularGradient;
      case CardValue.platinum:
        return CustomGradients.platimunGradient;
      default:
        return CustomGradients.disabledGradient;
    }
  }
}

CardValue randomCard() {
  int diceRoll = Random().nextInt(6) + 1;
  switch (diceRoll) {
    case 1:
      return CardValue.silver;
    case 2:
      return CardValue.silver;
    case 3:
      return CardValue.gold;
    case 4:
      return CardValue.gold;
    case 5:
      return CardValue.platinum;
    case 6:
      return CardValue.platinum;
    default:
      return CardValue.silver;
  }
}

class CardType extends StatelessWidget {
  const CardType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CardValue value = randomCard();
    return Stack(
      children: [
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(
            horizontal: 50.0,
          ),
          margin: const EdgeInsets.only(left: 80.0, right: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: CustomColors.customLigthGray,
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '\$90',
                style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w800,
                  fontSize: 20.0,
                ),
              ),
              Row(
                children: [
                  Text(
                    '\$100',
                    style: GoogleFonts.mulish(
                      color: CustomColors.discountColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    '10% OFF',
                    style: GoogleFonts.mulish(
                      color: CustomColors.discountPercentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: value.colorGradient,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.name,
                    style: GoogleFonts.mulish(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('assets/buy_card/coin.svg'),
                      const SizedBox(width: 5.0),
                      Text(
                        '1000',
                        style: GoogleFonts.mulish(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
