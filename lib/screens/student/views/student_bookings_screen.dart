import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../blocs/student_bookings_bloc/student_bookings_bloc.dart';

class StudentBookingsScreen extends StatefulWidget {
  const StudentBookingsScreen({super.key});

  @override
  State<StudentBookingsScreen> createState() => _StudentBookingsScreenState();
}

class _StudentBookingsScreenState extends State<StudentBookingsScreen> {
  @override
  void initState() {
    super.initState();
    final user = context.read<AuthenticationBloc>().state.user;
    if (user != null) {
      context.read<StudentBookingsBloc>().add(StudentBookingsRequested(user.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        title: const Text('My bookings'),
      ),
      body: BlocBuilder<StudentBookingsBloc, StudentBookingsState>(
        builder: (context, state) {
          if (state is StudentBookingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is StudentBookingsLoaded && state.bookings.isEmpty) {
            return const Center(child: Text('No bookings yet.'));
          }
          if (state is StudentBookingsLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session with ${booking.tutorId}',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Scheduled: ${booking.scheduledDate}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Status: ${booking.status.name}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}