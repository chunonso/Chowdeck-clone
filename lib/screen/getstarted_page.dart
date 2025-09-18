import 'package:chowdeck_refix/phoneauth_screen.dart';
import 'package:chowdeck_refix/screen/notification_alert.dart';
import 'package:chowdeck_refix/screen/otp_page.dart';
import 'package:chowdeck_refix/screen/textfieldarea.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
// import 'package:cloud_firestore/cloud_firestore.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _referralController = TextEditingController();

  Country _selectedCountry = Country(
    phoneCode: '1',
    countryCode: 'US',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'United States',
    example: '2015550123',
    displayName: 'United States',
    displayNameNoCountryCode: 'United States',
    e164Key: '',
    // flagEmoji: '🇺🇸',
  );

  Future<void> sendOTP() async {
    final fullPhone =
        '+${_selectedCountry.phoneCode}${_phoneController.text.trim()}';

    try {
      // 🔒 Step 1: Check if phone number already exists
      final existingUser =
          await FirebaseFirestore.instance
              .collection('users')
              .where('phoneNumber', isEqualTo: fullPhone)
              .limit(1)
              .get();
      if (!mounted) return;
      if (existingUser.docs.isNotEmpty) {
        NotificationAlert.showErrorAlert(
          context,
          "Phone number already exist, login instead",
        );
        // const SnackBar(content: Text('Phone number already registered')),

        Navigator.pop(context);
        return;
      }

      // ✅ Step 2: Send OTP if not registered
      await PhoneAuthentication().sendOTPCode(
        phoneNumber: fullPhone,
        onCodeSent: (String verId) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => OtpVerificationPage(
                    verification: verId,
                    phoneNumber: fullPhone,
                    email: _emailController.text.trim(),
                    firstName: _firstNameController.text.trim(),
                    lastName: _lastNameController.text.trim(),
                    birthday: _birthdayController.text.trim(),
                    referralCode: _referralController.text.trim(),
                  ),
            ),
          );
        },
        onFailed: (e) {
          NotificationAlert.showErrorAlert(context, "OTP failed");
        },
      );
    } catch (e) {
      if (!mounted) return;
      NotificationAlert.showErrorAlert(context, "Error");
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthdayController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: GestureDetector(
                  onTap: () {},
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Continue as guest",
                      style: TextStyle(
                        color: Color(0xFF00956B),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 18),
                  Center(
                    child: Text(
                      "Let's get started",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  Center(
                    child: Text(
                      "We just need a bit more information. Please\nenter your details to get started.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // COUNTRY & PHONE
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Country ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "*",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: "   "),
                            TextSpan(
                              text: "Phone number ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "*",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),

                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // important to align top
                        children: [
                          // Country picker
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showCountryPicker(
                                    context: context,
                                    showPhoneCode: true,
                                    countryListTheme: CountryListThemeData(
                                      bottomSheetHeight: 450,
                                      backgroundColor: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(18),
                                      ),
                                    ),
                                    onSelect: (Country country) {
                                      setState(
                                        () => _selectedCountry = country,
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: 60,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _selectedCountry.flagEmoji,
                                        style: TextStyle(fontSize: 21),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 21,
                                        color: Colors.teal,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // No validation under this field
                            ],
                          ),
                          SizedBox(width: 8),

                          // Phone Code (fixed)
                          Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade100,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '+${_selectedCountry.phoneCode}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // No validation under this field
                            ],
                          ),
                          SizedBox(width: 8),

                          // Phone Number Field
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NumberTexfield(
                                  phoneController: _phoneController,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 23),

                  // EMAIL
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Email address ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  EmailTextfield(emailController: _emailController),

                  SizedBox(height: 23),

                  // FIRST NAME & LAST NAME
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "First name ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "*",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                hintText: 'e.g John',
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? 'First name required'
                                          : null,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Last name ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "*",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                hintText: 'e.g Doe',
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? 'Last name required'
                                          : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 23),

                  // BIRTHDAY
                  Text(
                    "Birthday",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _birthdayController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Select your birthday',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.teal,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your birthday';
                      }
                      return null;
                    },
                    onTap: () async {
                      dt_picker.DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime.now(),
                        theme: dt_picker.DatePickerTheme(
                          headerColor: Colors.white,
                          backgroundColor: Colors.white,
                          itemStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          doneStyle: TextStyle(
                            color: Color(0xFF00956B),
                            fontSize: 16,
                          ),
                        ),
                        onConfirm: (date) {
                          setState(() {
                            _selectedDate = date;
                            _birthdayController.text =
                                "${date.month}/${date.day}";
                          });
                        },
                        currentTime: DateTime.now(),
                        locale: dt_picker.LocaleType.en,
                      );
                    },
                  ),

                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Colors.teal),
                      SizedBox(width: 4),
                      Text(
                        "Get free delivery and discounts on your birthday",
                        style: TextStyle(color: Colors.teal, fontSize: 13),
                      ),
                    ],
                  ),

                  SizedBox(height: 23),

                  // REFERRAL CODE
                  Text(
                    "Referral code",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  SizedBox(height: 8),
                  ReferralText(referralController: _referralController),

                  SizedBox(height: 35),

                  // CONTINUE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF114834),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await sendOTP();
                        }
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 18),

                  // TERMS
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text.rich(
                        TextSpan(
                          text: 'By signing up, you agree to Chowdeck’s ',
                          children: [
                            TextSpan(
                              text: 'Terms of use',
                              style: TextStyle(
                                color: Color(0xFF00956B),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy policy',
                              style: TextStyle(
                                color: Color(0xFF00956B),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
