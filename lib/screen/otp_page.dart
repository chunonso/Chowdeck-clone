import 'dart:async';
import 'package:chowdeck_refix/phoneauth_screen.dart';
import 'package:chowdeck_refix/screen/home_screen.dart';
import 'package:chowdeck_refix/screen/login_screen.dart';
import 'package:chowdeck_refix/screen/notification_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerificationPage extends StatefulWidget {
  final String verification;
  final String phoneNumber;
  final String email;
  final String firstName;
  final String lastName;
  final String birthday;
  final String referralCode;

  const OtpVerificationPage({
    super.key,
    required this.verification,
    required this.phoneNumber,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.referralCode,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _secondsRemaining = 60;
  late Timer _timer;
  bool _isVerifying = false;
  String? _errorMessage;
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verification;
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer.cancel();
      }
    });
  }

  Future<void> verifyOTP(String otpCode) async {
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      String result = await PhoneAuthentication().verifyOTPCode(
        verificationId: _verificationId,
        smsCode: otpCode,
        phoneNumber: widget.phoneNumber,
        email: widget.email,
        firstName: widget.firstName,
        lastName: widget.lastName,
        birthday: widget.birthday,
        referralCode: widget.referralCode,
      );

      if (!mounted) return;

      if (result == 'success') {
        NotificationAlert.showSuccessAlert(context, "Successful");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
            // HomePage(verification: '', phoneNumber: ''),
          ),
        );
      } else {
        NotificationAlert.showErrorAlert(context, "Verification failed");
        setState(() => _errorMessage = result.replaceFirst('error: ', ''));
      }
    } catch (e) {
      if (!mounted) return;
      NotificationAlert.showErrorAlert(context, "Unexpected error occurred");
      setState(() {
        _errorMessage = "Verification failed: ${e.toString()}";
      });
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Verify your number",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "We've sent a 6-digit code to ${widget.phoneNumber}",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Enter OTP *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOtpBox(index)),
            ),
            const SizedBox(height: 20),
            if (_isVerifying)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage != null)
              Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed:
                    _secondsRemaining == 0
                        ? () async {
                          await PhoneAuthentication().sendOTPCode(
                            phoneNumber: widget.phoneNumber,
                            onCodeSent: (newVerificationId) {
                              setState(() {
                                _verificationId = newVerificationId;
                                _secondsRemaining = 60;
                                _startCountdown();
                              });
                            },
                            onFailed: (e) {
                              setState(() {
                                NotificationAlert.showSuccessAlert(
                                  context,
                                  "Resend Failed",
                                );
                                // _errorMessage = "Resend failed: ${e.message}";
                              });
                            },
                          );
                        }
                        : null,
                child: Text(
                  _secondsRemaining == 0
                      ? "Tap here to resend OTP"
                      : "Tap here to resend OTP (${_secondsRemaining}s)",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF114834),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                onPressed:
                    _isVerifying
                        ? null
                        : () {
                          String otpCode =
                              _otpControllers.map((c) => c.text).join();
                          verifyOTP(otpCode);
                        },

                child: Text(
                  'Verify',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 50,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (val) {
          if (val.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (val.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          bool allFilled = _otpControllers.every(
            (c) => c.text.trim().isNotEmpty,
          );
          if (allFilled) {
            String otpCode = _otpControllers.map((c) => c.text).join();
            verifyOTP(otpCode);
          }
        },
      ),
    );
  }
}
