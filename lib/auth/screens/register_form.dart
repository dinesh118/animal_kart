import 'dart:io';
import 'package:animal_kart_demo2/auth/providers/auth_provider.dart';
import 'package:animal_kart_demo2/routes/routes.dart';
import 'package:animal_kart_demo2/theme/app_theme.dart';
import 'package:animal_kart_demo2/utils/app_colors.dart';
import 'package:animal_kart_demo2/auth/widgets/aadharvalidation_widget.dart';
import 'package:animal_kart_demo2/widgets/custom_widgets.dart';
import 'package:animal_kart_demo2/widgets/floating_toast.dart';
import 'package:animal_kart_demo2/auth/widgets/aadhar_upload_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String phoneNumberFromLogin;

  const RegisterScreen({super.key, required this.phoneNumberFromLogin});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final occupationCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final aadhaarCtrl = TextEditingController();

  File? aadhaarFront;
  File? aadhaarBack;
  // Removed aadhaarUrls map

  String gender = "Male";
  DateTime? selectedDOB;

  ///age calculation
  int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFieldBg,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Register Your Account !",
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Welcome, Please Enter Your Details.",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 25),

                      // CONTACT SECTION
                      const Text(
                        "Contact Information",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Card(
                        color: akWhiteColor,

                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Phone Number",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // READ ONLY PHONE NUMBER
                              Container(
                                height: 55,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: kFieldBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "+91 ${widget.phoneNumberFromLogin}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),
                              const Text(
                                "Email ID",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),

                              TextFormField(
                                controller: emailCtrl,
                                decoration: fieldDeco("Email ID"),
                                validator: (v) =>
                                    v!.contains("@") ? null : "Enter a valid email",
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // PERSONAL SECTION
                      const Text(
                        "Personal Information",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: akWhiteColor,

                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "First Name",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: firstNameCtrl,
                                decoration: fieldDeco("First Name"),
                                validator: (v) => v!.isEmpty ? "Required" : null,
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "Family Name",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: lastNameCtrl,
                                decoration: fieldDeco("Family Name"),
                                validator: (v) => v!.isEmpty ? "Required" : null,
                              ),

                              const SizedBox(height: 20),

                              const Text("Gender"),
                              Row(
                                children: [
                                  genderButton(
                                    label: "Male",
                                    selectedGender: gender,
                                    onChanged: (val) => setState(() => gender = val),
                                  ),
                                  genderButton(
                                    label: "Female",
                                    selectedGender: gender,
                                    onChanged: (val) => setState(() => gender = val),
                                  ),
                                  genderButton(
                                    label: "Others",
                                    selectedGender: gender,
                                    onChanged: (val) => setState(() => gender = val),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                              const Text(
                                "Occupation",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: occupationCtrl,
                                decoration: fieldDeco("Occupation"),
                              ),

                              const SizedBox(height: 15),
                              const Text(
                                "Date of Birth",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // DOB PICKER
                              TextFormField(
                                controller: dobCtrl,
                                readOnly: true,
                                decoration: fieldDeco("Date of Birth").copyWith(
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_month),
                                    onPressed: selectDOB,
                                  ),
                                ),
                                validator: (v) => v!.isEmpty ? "Select DOB" : null,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Address Information",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: akWhiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Address",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: addressCtrl,
                                maxLines: 3,
                                decoration: fieldDeco("Address"),
                                validator: (v) => v!.isEmpty ? "Required" : null,
                              ),

                              const SizedBox(height: 20),

                              const SizedBox(height: 8),
                              TextFormField(
                                controller: aadhaarCtrl,
                                decoration: fieldDeco("Aadhaar Number (Optional)"),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                maxLength: 12,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return null;
                                  if (!AadharValidator.validateAadhar(value)) {
                                    return "Enter a valid Aadhaar number";
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 25),

                              // Aadhaar Front
                              AadhaarUploadWidget(
                                title: "Upload Aadhaar Front Image",
                                file: aadhaarFront,
                                isFrontImage: true,
                                onCamera: () async {
                                  final file = await pickFromCamera();
                                  if (file != null) {
                                    setState(() => aadhaarFront = file);
                                  }
                                },
                                onGallery: () async {
                                  final file = await pickImage();
                                  if (file != null) {
                                    setState(() => aadhaarFront = file);
                                  }
                                },
                                onRemove: () {
                                  setState(() => aadhaarFront = null);
                                },
                              ),

                              const SizedBox(height: 25),

                              AadhaarUploadWidget(
                                title: "Upload Aadhaar Back Image",
                                file: aadhaarBack,
                                isFrontImage: false,
                                onCamera: () async {
                                  final file = await pickFromCamera();
                                  if (file != null) {
                                    setState(() => aadhaarBack = file);
                                  }
                                },
                                onGallery: () async {
                                  final file = await pickImage();
                                  if (file != null) {
                                    setState(() => aadhaarBack = file);
                                  }
                                },
                                onRemove: () {
                                  setState(() => aadhaarBack = null);
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Fixed register button at bottom
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kFieldBg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // PICK IMAGE ------
  Future<File?> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    return picked != null ? File(picked.path) : null;
  }

  Future<File?> pickFromCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    return picked != null ? File(picked.path) : null;
  }

  // SELECT DOB ------
  Future<void> selectDOB() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 21),
      firstDate: DateTime(1960),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: kPrimaryGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDOB = picked;
      dobCtrl.text = "${picked.month}-${picked.day}-${picked.year}";
    }
  }

  // SUBMIT FORM ------
  void submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDOB == null) {
      FloatingToast.showSimpleToast("Please select your Date of Birth");
      return;
    }

    int age = calculateAge(selectedDOB!);
    if (age < 21) {
      FloatingToast.showSimpleToast("You must be at least 21 years old to register");
      return;
    }

    // AADHAAR VALIDATION in submit
    if (aadhaarCtrl.text.trim().isNotEmpty) {
      bool isValid = AadharValidator.validateAadhar(aadhaarCtrl.text.trim());
      if (!isValid) {
        FloatingToast.showSimpleToast("Invalid Aadhaar number");
        return;
      }
    }

    final auth = ref.read(authProvider.notifier);
    final userId = widget.phoneNumberFromLogin;

    final extraFields = <String, dynamic>{
      'name': '${firstNameCtrl.text} ${lastNameCtrl.text}'.trim(),
      'email': emailCtrl.text.trim(),
      'address': addressCtrl.text.trim(),
      'occupation': occupationCtrl.text.trim(),
      'isFormFilled': true,
      'gender': gender,
      'dob': dobCtrl.text.trim(),
      'aadhar_number': int.tryParse(aadhaarCtrl.text.trim()),
      'first_name': firstNameCtrl.text.trim(),
      "last_name": lastNameCtrl.text.trim(),
    };

    // Removed Aadhaar URL fields from extraFields

    final success = await auth.updateUserdata(
      userId: userId,
      extraFields: extraFields,
    );

    if (!mounted) return;
    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isProfileCompleted', true);

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      FloatingToast.showSimpleToast(
        'Failed to update profile. Please try again.',
      );
    }
  }
}