import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:salon_glam/widgets/custom_app_bar.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: 'Feedback', // Title for the app bar
      bodyContent: _FeedbackBody(), // Body content as a separate widget
    );
  }
}

class _FeedbackBody extends StatefulWidget {
  const _FeedbackBody();

  @override
  State<_FeedbackBody> createState() => _FeedbackBodyState();
}

class _FeedbackBodyState extends State<_FeedbackBody> {
  double _rating = 0; // Initial rating value
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _submitFeedback() async {
    String feedback = _feedbackController.text; // Get the feedback

    // Check if feedback is not empty
    if (feedback.isNotEmpty) {
      // Store feedback in Firestore
      await FirebaseFirestore.instance.collection('Feedbacks').add({
        'rating': _rating,
        'feedback': feedback,
        'timestamp': FieldValue
            .serverTimestamp(), // Timestamp for when feedback was submitted
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted!')),
      );

      // Clear the feedback text field and reset rating
      _feedbackController.clear();
      setState(() {
        _rating = 0; // Reset rating after submission
      });
    } else {
      // Show error message if feedback is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter feedback before submitting.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Added scroll functionality
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Centered heading
              const Center(
                child: Text(
                  'Feedback',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20.0),

              // What do you think of our services text
              const Text(
                'What do you think of our services?',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10.0),

              // Star Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0; // Update the rating
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20.0),

              // Tell us what you think text
              const Text(
                'Tell us what you think:',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),

              // Feedback TextBox
              TextField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your feedback here...',
                ),
              ),
              const SizedBox(height: 20.0),

              // Centered Submit button
              Center(
                child: ElevatedButton(
                  onPressed: _submitFeedback, // Call the submit method
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
