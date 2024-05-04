import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:variancedemo/providers/wallet_provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController controller = TextEditingController();
  FToast? fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast?.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<WalletProvider>(
          builder: (context, value, child) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 51, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 50),
                  24.verticalSpace,
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: TextButton.icon(
                        onPressed: () {
                          try {
                            context.read<WalletProvider>().createSmartWallet();
                            Navigator.pushNamed(context, '/home');
                          } catch (e) {
                            'Something went wrong: $e';
                          }
                        },
                        icon: const Icon(Icons.key),
                        label: const Text('Create Smart Account')),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
