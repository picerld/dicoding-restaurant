import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/restaurant_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ReviewForm extends StatefulWidget {
  final String restaurantId;
  const ReviewForm({super.key, required this.restaurantId});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

Widget buildToast(BuildContext context, ToastOverlay overlay) {
  return SurfaceCard(
    child: Basic(
      title: const Text('Successfully!'),
      subtitle: const Text('Your review is submited!!!'),
    ),
  );
}

class _ReviewFormState extends State<ReviewForm> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  void _submit() {
    final name = _nameController.text.trim();
    final review = _reviewController.text.trim();
    if (name.isNotEmpty && review.isNotEmpty) {
      Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).addReview(widget.restaurantId, name, review);

      _nameController.clear();
      _reviewController.clear();

      showToast(
        context: context,
        builder: buildToast,
        location: ToastLocation.bottomRight,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Review").h4,
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              placeholder: Text("Your Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reviewController,
              placeholder: Text("Your Review"),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            PrimaryButton(onPressed: _submit, child: const Text("Submit")),
          ],
        ),
      ),
    );
  }
}
