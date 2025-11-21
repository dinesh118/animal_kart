import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // STATIC DATA
    const String userName = "Sai Krishna";
    const String phoneNumber = "+91 9640852825";
    const String email = "Sanjaykiran640@gmail.com";
    const String gender = "Male";
    const String dob = "08-06-1995";
    const String aadhar = "7966*****";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [

            
           

            const SizedBox(height: 20),

            // ---------- PERSONAL INFORMATION ----------
            _infoCard(
              title: "Personal Information",
              items: const {
                "Name":userName,
                "number":phoneNumber,
                "Email ID": email,
                "Gender": gender,
                "Date of Birth": dob,
              },
            ),

            const SizedBox(height: 20),

            // ---------- AADHAAR ----------
            _infoCard(
              title: "Aadhaar Card Number",
              items: const {
                "": aadhar,
              },
            ),

            const SizedBox(height: 40),

            // ---------- LOGOUT BUTTON ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD6D6),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Center(
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------
// REUSABLE CARD WIDGET
// ---------------------------------------------
Widget _infoCard({
  required String title,
  required Map<String, String> items,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(18),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),

        ...items.entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (e.key.isNotEmpty)
                  Text(
                    e.key,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  e.value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
