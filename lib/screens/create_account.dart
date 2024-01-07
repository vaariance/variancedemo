import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:variancedemo/providers/wallet_provider.dart';
import 'package:variancedemo/utils/widgets.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25)),
                        child: TextFormField(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                            if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                              return 'Username must contain only alphabets with no spaces';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              controller.text = value;
                            });
                          },
                          controller: controller,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              hintText: 'Choose a username',
                              hintStyle: TextStyle(
                                fontSize: 20.sp,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true),
                        ),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        height: 45.h,
                        child: TextButton(
                          onPressed: () async {
                            try {
                              await value.registerWithPassKey(controller.text,
                                  requiresUserVerification: true);
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(context, '/home');
                            } catch (e) {
                              showSnackbar(e.toString());
                            }
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: const Color(0xffE1FF01),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                  18.verticalSpace,
                  Container(
                      margin: const EdgeInsets.only(left: 135),
                      child: Text('OR', style: TextStyle(fontSize: 18.sp))),
                  24.verticalSpace,
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: TextButton.icon(
                        onPressed: () {
                          try {
                            context
                                .read<WalletProvider>()
                                .registerWithHDWallet();
                            Navigator.pushNamed(context, '/home');
                          } catch (e) {
                            'Something went wrong: $e';
                          }
                        },
                        icon: const Icon(Icons.key),
                        label: const Text('Generate Account with HD Key')),
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
