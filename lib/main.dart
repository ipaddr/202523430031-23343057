import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/auth/bloc/auth_bloc.dart';
import 'services/auth/bloc/auth_event.dart';
import 'services/auth/bloc/auth_state.dart';
import 'themes.dart';
import 'views/login_view.dart';
import 'views/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authService: AuthService())
        ..add(AuthCheckRequested()),
      child: MaterialApp(
        title: 'Motifa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: MotifaTheme.backgroundWhite,
          colorScheme: ColorScheme.fromSeed(seedColor: MotifaTheme.primaryBlue),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const MainView();
            }
            return const LoginView();
          },
        ),
      ),
    );
  }
}
