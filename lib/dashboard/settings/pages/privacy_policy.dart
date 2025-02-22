import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Privacy Policy",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "1. Introduction",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Welcome to AquaTrack! Your privacy is important to us. This Privacy Policy explains how we collect, use, and safeguard your information.",
            ),
            const SizedBox(height: 20),
            const Text(
              "2. Information We Collect",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "• Personal Data: When you create an account, we collect your name, email, age, gender, weight, and other health-related details.\n"
              "• Usage Data: We collect data on how you use the app, such as water intake logs and app interactions.\n"
              "• Device Information: We may collect details about your device, such as model and OS version.",
            ),
            const SizedBox(height: 20),
            const Text(
              "3. How We Use Your Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "• To provide and improve the app’s functionality.\n"
              "• To personalize your experience.\n"
              "• To analyze usage trends and improve user experience.\n"
              "• To ensure data security and prevent unauthorized access.",
            ),
            const SizedBox(height: 20),
            const Text(
              "4. Data Security",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "We take data security seriously and implement appropriate measures to protect your personal information.",
            ),
            const SizedBox(height: 20),
            const Text(
              "5. Third-Party Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "We may use third-party services for analytics or storage. These services have their own privacy policies.",
            ),
            const SizedBox(height: 20),
            const Text(
              "6. Changes to this Policy",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "We may update this Privacy Policy from time to time. Any changes will be reflected in the app.",
            ),
            const SizedBox(height: 20),
            const Text(
              "7. Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 5),
            const Text(
              "If you have any questions about this Privacy Policy, please contact us at support@aquatrack.com.",
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back to Settings"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
