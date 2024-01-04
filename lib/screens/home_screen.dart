import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:variancedemo/variance_colors.dart';

class WalletHome extends StatefulWidget {
  const WalletHome({super.key});

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  final List<CryptoTransaction> transactions = [
    CryptoTransaction(name: 'Bitcoin', amount: 0.05, date: '2022-01-01'),
    CryptoTransaction(name: 'Ethereum', amount: 1.2, date: '2022-02-15'),
    CryptoTransaction(name: 'Litecoin', amount: 5.0, date: '2022-03-10'),
    // Add more transactions as needed
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: VarianceColors.primary,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 19.h, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WalletBalance(),
              18.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45.h,
                      width: 180.w,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: VarianceColors.white),
                          onPressed: () {},
                          child: const Text('Send')),
                    ),
                  ),
                  20.horizontalSpace,
                  Expanded(
                    child: SizedBox(
                      height: 45.h,
                      width: 180,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: VarianceColors.secondary),
                          onPressed: () {},
                          child: const Text('Receive')),
                    ),
                  )
                ],
              ),
              18.verticalSpace,
              // Container(
              //   child: ListView.builder(
              //     itemCount: transactions.length,
              //     itemBuilder: (context, index) {
              //       final transaction = transactions[index];
              //       return ListTile(
              //         title: Text(transaction.name),
              //         subtitle: Text('Amount: ${transaction.amount} BTC'),
              //         trailing: Text('Date: ${transaction.date}'),
              //         // You can customize the ListTile further as needed
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletBalance extends StatelessWidget {
  const WalletBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Total Balance',
              style:
                  TextStyle(color: VarianceColors.secondary, fontSize: 14.sp),
            ),
            10.horizontalSpace,
            const Image(
              image: AssetImage(
                'assets/images/down-arrow.png',
              ),
              height: 10,
              width: 10,
              color: VarianceColors.secondary,
            )
          ],
        ),
        18.verticalSpace,
        Text(
          'Eth 0.00',
          style: TextStyle(color: Colors.white, fontSize: 24.sp),
        ),
        18.verticalSpace,
        Text(
          '0.00 USD',
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ],
    );
  }
}

class CryptoTransaction {
  final String name;
  final double amount;
  final String date;

  CryptoTransaction({
    required this.name,
    required this.amount,
    required this.date,
  });
}
