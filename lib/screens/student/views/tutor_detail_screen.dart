import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_repository/tutor_repository.dart';

import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/booking_bloc/booking_bloc.dart';

class TutorDetailScreen extends StatelessWidget {
  final TutorSubject tutor;

  const TutorDetailScreen(this.tutor, {super.key});

  Future<void> _requestBooking(BuildContext context) async {
    final theme = Theme.of(context);
    final bookingBloc = context.read<BookingBloc>();
    final authState = context.read<AuthenticationBloc>().state;
    final student = authState.user;

    if (student == null) {
      return;
    }

    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now().add(const Duration(days: 1)),
    );

    if (date == null) {
      return;
    }

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );

    if (time == null) {
      return;
    }

    final scheduledDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final booking = Booking(
      bookingId: DateTime.now().microsecondsSinceEpoch.toString(),
      studentId: student.userId,
      tutorId: tutor.tutorId,
      scheduledDate: scheduledDate,
      status: BookingStatus.pending,
      meetLink: 'TBD',
    );

    bookingBloc.add(CreateBooking(booking));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Booking request sent.'),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        title: Text(tutor.subjectName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                  child: Text(
                    tutor.subjectName.substring(0, 1).toUpperCase(),
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tutor.subjectName,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.star, color: theme.colorScheme.primary),
                          const SizedBox(width: 4),
                          Text('${tutor.rating.toStringAsFixed(1)} rating'),
                          const SizedBox(width: 12),
                          if (tutor.isVerified)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Verified',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSecondary,
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Teaching style',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              tutor.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rate per hour',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${tutor.pricePerHour.toStringAsFixed(0)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _requestBooking(context),
                    child: const Text('Request booking'),
                  )
                ],
              ),
            ),
            const Spacer(),
            BlocBuilder<BookingBloc, BookingState>(
              builder: (context, state) {
                if (state is BookingSubmitting) {
                  return const LinearProgressIndicator();
                }
                if (state is BookingFailure) {
                  return Text(
                    'Could not create booking. Try again.',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
