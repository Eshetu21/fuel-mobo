import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuel_finder/features/auth/presentation/pages/login_page.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailVerification extends StatefulWidget {
  final String email;
  final String userId;
  const EmailVerification({
    super.key,
    required this.email,
    required this.userId,
  });

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.1),
              Text(
                "Verify Your Email",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "We've sent a 6-digit verification code to",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                widget.email,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: pinController,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  activeColor: AppPallete.primaryColor,
                  selectedColor: AppPallete.primaryColor,
                  inactiveColor: Colors.grey,
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      ShowSnackbar.show(context, state.message);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else if (state is AuthFailure) {
                      ShowSnackbar.show(context, state.error, isError: true);
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final code = pinController.text.trim();
                        if (code.isEmpty) {
                          ShowSnackbar.show(
                            context,
                            "Please enter the verification code.",
                          );
                          return;
                        }

                        print('Token frontend: $code');
                        context.read<AuthBloc>().add(
                          AuthVerifyEmailEvent(
                            userId: widget.userId,
                            token: code,
                          ),
                        );
                      },

                      child:
                          state is AuthLoading
                              ? CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                              : Text(
                                "Verify Account",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive a code? ",
                    style: theme.textTheme.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () {
                      ShowSnackbar.show(context, "Verification code resent!");
                    },
                    child: Text(
                      "Resend",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppPallete.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Back to registration",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPallete.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

