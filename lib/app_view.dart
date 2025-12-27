import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:pizza_app/screens/auth/blocs/sing_in_bloc/sign_in_bloc.dart';
import 'package:pizza_app/screens/auth/views/welcome_screen.dart';
import 'package:pizza_app/screens/student/blocs/student_bookings_bloc/student_bookings_bloc.dart';
import 'package:pizza_app/screens/student/blocs/tutor_discover_bloc/tutor_discover_bloc.dart';
import 'package:pizza_app/screens/student/views/student_home_screen.dart';
import 'package:pizza_app/screens/tutor/blocs/tutor_bookings_bloc/tutor_bookings_bloc.dart';
import 'package:pizza_app/screens/tutor/blocs/tutor_profile_bloc/tutor_profile_bloc.dart';
import 'package:pizza_app/screens/tutor/views/tutor_dashboard_screen.dart';
import 'package:tutor_repository/tutor_repository.dart';
import 'package:user_repository/user_repository.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tutorly',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.light(
            background: Color(0xFFF5F4F0),
            onBackground: Color(0xFF1C1C1C),
            primary: Color(0xFF2356D8),
            onPrimary: Colors.white,
            secondary: Color(0xFFF4B24D),
            onSecondary: Color(0xFF1C1C1C),
            surface: Colors.white,
          ),
          textTheme: GoogleFonts.spaceGroteskTextTheme(),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2356D8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: ((context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              final user = state.user!;
              if (user.role == UserRole.tutor) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => SignInBloc(
                        context.read<AuthenticationBloc>().userRepository,
                      ),
                    ),
                    BlocProvider(
                      create: (context) => TutorProfileBloc(
                        FirebaseTutorRepo(),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => TutorBookingsBloc(
                        FirebaseTutorRepo(),
                      ),
                    ),
                  ],
                  child: const TutorDashboardScreen(),
                );
              }

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(
                      context.read<AuthenticationBloc>().userRepository,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => TutorDiscoverBloc(
                      FirebaseTutorRepo(),
                    )..add(LoadTopRatedTutors()),
                  ),
                  BlocProvider(
                    create: (context) => StudentBookingsBloc(
                      FirebaseTutorRepo(),
                    ),
                  ),
                ],
                child: const StudentHomeScreen(),
              );
            } else {
              return const WelcomeScreen();
            }
          }),
        ));
  }
}
