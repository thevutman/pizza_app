import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_repository/tutor_repository.dart';

import '../../../blocs/authentication_bloc/authentication_bloc.dart';
import '../../auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import '../blocs/tutor_bookings_bloc/tutor_bookings_bloc.dart';
import '../blocs/tutor_profile_bloc/tutor_profile_bloc.dart';

class TutorDashboardScreen extends StatefulWidget {
  const TutorDashboardScreen({super.key});

  @override
  State<TutorDashboardScreen> createState() => _TutorDashboardScreenState();
}

class _TutorDashboardScreenState extends State<TutorDashboardScreen> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthenticationBloc>().state.user;
    if (user != null) {
      context.read<TutorProfileBloc>().add(LoadTutorProfile(user.userId));
      context.read<TutorBookingsBloc>().add(TutorBookingsRequested(user.userId));
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveProfile(BuildContext context, String tutorId) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final profile = TutorSubject(
      tutorId: tutorId,
      subjectName: _subjectController.text.trim(),
      description: _descriptionController.text.trim(),
      pricePerHour: double.parse(_priceController.text.trim()),
      rating: 0,
      isVerified: false,
    );

    context.read<TutorProfileBloc>().add(SaveTutorProfile(profile));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.read<AuthenticationBloc>().state.user;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        title: const Text('Tutor dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(SignOutRequired());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your teaching profile',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            BlocConsumer<TutorProfileBloc, TutorProfileState>(
              listener: (context, state) {
                if (state is TutorProfileSaved) {
                  _subjectController.text = state.profile.subjectName;
                  _descriptionController.text = state.profile.description;
                  _priceController.text = state.profile.pricePerHour.toStringAsFixed(0);
                }
              },
              builder: (context, state) {
                if (state is TutorProfileLoading || state is TutorProfileSaving) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TutorProfileFailure) {
                  return const Text('Could not load your profile.');
                }

                final profile = state is TutorProfileLoaded ? state.profile :
                    state is TutorProfileSaved ? state.profile : null;

                if (profile != null) {
                  return _ProfileCard(profile: profile);
                }

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _subjectController,
                        decoration: const InputDecoration(
                          labelText: 'Main subject',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter a subject.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Teaching style',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Describe your teaching style.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price per hour',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Price must be a number.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (user != null) {
                              _saveProfile(context, user.userId);
                            }
                          },
                          child: const Text('Create profile'),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Upcoming sessions',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            BlocBuilder<TutorBookingsBloc, TutorBookingsState>(
              builder: (context, state) {
                if (state is TutorBookingsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TutorBookingsLoaded && state.bookings.isEmpty) {
                  return const Text('No bookings yet.');
                }
                if (state is TutorBookingsLoaded) {
                  return Column(
                    children: state.bookings.map((booking) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
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
                                  'Student: ${booking.studentId}',
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  booking.scheduledDate.toString(),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Chip(
                              label: Text(booking.status.name),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
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

class _ProfileCard extends StatelessWidget {
  final TutorSubject profile;

  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(profile.subjectName, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(profile.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rate: \$${profile.pricePerHour.toStringAsFixed(0)}/hr'),
              Text(profile.isVerified ? 'Verified' : 'Pending verification'),
            ],
          )
        ],
      ),
    );
  }
}
