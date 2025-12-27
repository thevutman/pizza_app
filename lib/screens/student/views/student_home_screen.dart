import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_repository/tutor_repository.dart';

import '../../auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import '../blocs/booking_bloc/booking_bloc.dart';
import '../blocs/tutor_discover_bloc/tutor_discover_bloc.dart';
import 'student_bookings_screen.dart';
import 'tutor_detail_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _subjects = const [
    'Math',
    'English',
    'Physics',
    'Chemistry',
    'History',
    'Programming',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find a tutor',
              style: theme.textTheme.titleLarge,
            ),
            Text(
              'Book live sessions in minutes',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const StudentBookingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.calendar_month),
          ),
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(SignOutRequired());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context
                      .read<TutorDiscoverBloc>()
                      .add(SearchTutorsBySubject(value.trim()));
                }
              },
              decoration: InputDecoration(
                hintText: 'Search by subject',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    context
                        .read<TutorDiscoverBloc>()
                        .add(LoadTopRatedTutors());
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final subject = _subjects[index];
                  return ActionChip(
                    label: Text(subject),
                    onPressed: () {
                      context
                          .read<TutorDiscoverBloc>()
                          .add(SearchTutorsBySubject(subject));
                    },
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: _subjects.length,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<TutorDiscoverBloc, TutorDiscoverState>(
                builder: (context, state) {
                  if (state is TutorDiscoverLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is TutorDiscoverFailure) {
                    return const Center(child: Text('Could not load tutors.'));
                  }
                  final tutors =
                      state is TutorDiscoverSuccess ? state.tutors : <TutorSubject>[];

                  if (tutors.isEmpty) {
                    return const Center(child: Text('No tutors found.'));
                  }

                  return ListView.separated(
                    itemCount: tutors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final tutor = tutors[index];
                      return _TutorCard(
                        tutor: tutor,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => BlocProvider(
                                create: (context) => BookingBloc(
                                  FirebaseTutorRepo(),
                                ),
                                child: TutorDetailScreen(tutor),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorCard extends StatelessWidget {
  final TutorSubject tutor;
  final VoidCallback onTap;

  const _TutorCard({
    required this.tutor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                child: Text(
                  tutor.subjectName.substring(0, 1).toUpperCase(),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutor.subjectName,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tutor.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.star, color: theme.colorScheme.primary, size: 16),
                        const SizedBox(width: 4),
                        Text('${tutor.rating.toStringAsFixed(1)}'),
                        const SizedBox(width: 8),
                        if (tutor.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '\$${tutor.pricePerHour.toStringAsFixed(0)}/hr',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
