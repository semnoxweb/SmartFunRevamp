import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:semnox/colors/colors.dart';
import 'package:semnox/core/domain/entities/card_details/account_credit_plus_dto_list.dart';
import 'package:semnox/core/widgets/custom_app_bar.dart';
import 'package:semnox/core/widgets/mulish_text.dart';
import 'package:semnox/core/utils/extensions.dart';
import 'package:semnox/features/cards_detail/bonus_summary_page.dart';

class BonusSummaryDetailPage extends StatelessWidget {
  const BonusSummaryDetailPage({Key? key, required this.summary}) : super(key: key);
  final AccountCreditPlusDTOList summary;
  

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBarCustomWidget(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MulishText(
              text: summary.remarks,
              fontColor: CustomColors.customBlue,
              fontWeight: FontWeight.bold,
            ),
            MulishText(
              text: '${summary.periodFrom.formatDate(DateFormat.YEAR_ABBR_MONTH_DAY)} - ${summary.periodFrom.formatDate(DateFormat.HOUR_MINUTE)}',
              fontColor: CustomColors.customBlue,
              fontSize: 16.0,
            ),
          ],
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: CustomColors.customLigthGray,
                      ),
                    ),
                    child: Column(
                      children: [
                        const MulishText(
                          text: 'Valid From',
                          fontWeight: FontWeight.bold,
                        ),
                        MulishText(text: summary.periodFrom.formatDate('dd MMM yyyy')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: CustomColors.customLigthGray,
                      ),
                    ),
                    child: Column(
                      children: [
                        const MulishText(
                          text: 'Valid To',
                          fontWeight: FontWeight.bold,
                        ),
                        MulishText(text: summary.periodTo.formatDate('dd MMM yyyy')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            TotalBonusBalance(
              totalBonus: summary.creditPlusBalance.toInt(),
            ),
            const SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.left,
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.check_circle, size: 18, color: Colors.greenAccent),
                    ),
                    TextSpan(
                      text: " Can be used to purchase below packages",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width * 0.90,
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                  return CustomColors.customOrange; // Use the default value.
                }),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.customLigthGray),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Category',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Package',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Qty',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: const <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('--')),
                      DataCell(Text('--')),
                      DataCell(Text('--')),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.start,
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.remove_circle, size: 18, color: Colors.red),
                    ),
                    TextSpan(
                      text: " Below packages are excluded",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width * 0.90,
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                  return CustomColors.customOrange; // Use the default value.
                }),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.customLigthGray),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Category',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Package',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        '',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: const <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('--')),
                      DataCell(Text('--')),
                      DataCell(Text('')),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.left,
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.check_circle, size: 18, color: Colors.greenAccent),
                    ),
                    TextSpan(
                      text: " Can be used to play below games",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width * 0.90,
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                  return CustomColors.customOrange; // Use the default value.
                }),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.customLigthGray),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Category',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Game',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Qty',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: const <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('--')),
                      DataCell(Text('--')),
                      DataCell(Text('--')),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.start,
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    WidgetSpan(
                      child: Icon(Icons.remove_circle, size: 18, color: Colors.red),
                    ),
                    TextSpan(
                      text: " Below games are excluded",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width * 0.90,
              child: DataTable(
                headingRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                  return CustomColors.customOrange; // Use the default value.
                }),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.customLigthGray),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Category',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Game',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        '',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: const <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('--')),
                      DataCell(Text('--')),
                      DataCell(Text('')),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
