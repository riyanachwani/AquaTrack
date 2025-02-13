import 'dart:developer';

import 'package:aquatrack/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() async {
    log("Current theme: ${Theme.of(context).brightness}");
    String feedback = _feedbackController.text.trim();
    if (feedback.isNotEmpty) {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'riyanachwani22@gmail.com',
        queryParameters: {
          'subject': 'App Feedback',
          'body': feedback,
        },
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open email app")),
        );
      }

      _feedbackController.clear();
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(title: const Text("Feedback")),
  backgroundColor: theme == Brightness.light ? Colors.white : Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We'd love to hear your thoughts!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Type your feedback here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
